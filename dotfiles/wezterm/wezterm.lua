-- Pull in the wezterm API
local wezterm = require("wezterm")
-- Claude Code の実行状態を監視するヘルパー
local agent = require("agent")

-- This will hold the configuration.
local config = wezterm.config_builder()

function merge_config(config, new_config)
	for k, v in pairs(new_config) do
		config[k] = v
	end
end

-- This is where you actually apply your config choices
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
-- update-status からサブプロセス起動を排除したので短い間隔で回せる
config.status_update_interval = 2000

config.color_scheme = "JetBrains Darcula"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
config.window_frame = {
	font = wezterm.font("JetBrains Mono", { italic = true }),
	active_titlebar_bg = "#47266e",
}

config.inactive_pane_hsb = {
	saturation = 0.7,
	brightness = 0.5,
}

config.tab_bar_at_bottom = true
config.enable_scroll_bar = true
config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"
config.window_background_opacity = 0.9

local act = wezterm.action

-- Helper function to run a command in an overlay pane
local function spawn_overlay_pane()
	return wezterm.action_callback(function(window, pane)
		local new_pane = pane:split({
			direction = "Bottom",
			args = { "/opt/homebrew/bin/bash", "--login" },
		})
		window:perform_action(act.TogglePaneZoomState, new_pane)
	end)
end

config.leader = { key = "q", mods = "CTRL" }
config.keys = {
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{ key = "h", mods = "LEADER|CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER|CTRL", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER|CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER|CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "r", mods = "LEADER|CTRL", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	{ key = "f", mods = "LEADER", action = wezterm.action.QuickSelect },
	{ key = "c", mods = "ALT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "ALT", action = wezterm.action.PasteFrom("Clipboard") },
	{
		key = "c",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
	{ key = "n", mods = "LEADER|CTRL", action = act.SwitchWorkspaceRelative(1) },
	{ key = "p", mods = "LEADER|CTRL", action = act.SwitchWorkspaceRelative(-1) },
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{
		key = "t",
		mods = "ALT",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "o",
		mods = "LEADER",
		action = spawn_overlay_pane(),
	},
	-- Claude Code のセッション一覧を開き、選んだペインへジャンプする
	{
		key = "a",
		mods = "LEADER",
		action = agent.dashboard_action(),
	},
}

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#696969"
	local foreground = "#FFFFFF"

	if tab.is_active then
		background = "#8b008b"
		foreground = "#FFFFFF"
	end

	-- Claude Code が居るタブに印を付ける (running を優先)。
	-- キャッシュ参照のみなので描画のたびに ps が走ることはない
	local marker = ""
	for _, p in ipairs(tab.panes) do
		local status = agent.pane_status(p.pane_id)
		if status == "running" then
			marker = "🔵 "
			break
		elseif status == "idle" then
			marker = "⚫ "
		end
	end

	local title = "  " .. marker .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
	}
end)

wezterm.on("augment-command-palette", function()
	return agent.palette_entries()
end)

wezterm.on("update-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	-- Figure out the cwd and host of the current pane.
	-- This will pick up the hostname for the remote host if your
	-- shell is using OSC 7 on the remote host.
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		local cwd = ""
		local hostname = ""

		if type(cwd_uri) == "userdata" then
			-- Running on a newer version of wezterm and we have
			-- a URL object here, making this simple!

			cwd = cwd_uri.file_path
			hostname = cwd_uri.host or wezterm.hostname()
		else
			-- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
			-- which doesn't have the Url object
			cwd_uri = cwd_uri:sub(8)
			local slash = cwd_uri:find("/")
			if slash then
				hostname = cwd_uri:sub(1, slash - 1)
				-- and extract the cwd from the uri, decoding %-encoding
				cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
					return string.char(tonumber(hex, 16))
				end)
			end
		end

		-- Remove the domain name portion of the hostname
		local dot = hostname:find("[.]")
		if dot then
			hostname = hostname:sub(1, dot - 1)
		end
		if hostname == "" then
			hostname = wezterm.hostname()
		end

		local home = os.getenv("HOME")
		if home and cwd:sub(1, #home) == home then
			cwd = "~" .. cwd:sub(#home + 1)
		end

		-- Shorten path: keep first letter of each directory except the last one
		local function shorten_path(path)
			local parts = {}
			local is_home = path:sub(1, 1) == "~"
			local start_idx = is_home and 2 or 1

			-- Split path by /
			for part in path:sub(start_idx):gmatch("[^/]+") do
				table.insert(parts, part)
			end

			-- Shorten all but the last directory
			for i = 1, #parts - 1 do
				parts[i] = parts[i]:sub(1, 1)
			end

			-- Reconstruct path
			local result = is_home and "~/" or "/"
			result = result .. table.concat(parts, "/")

			-- Add trailing slash if original had one
			if path:sub(-1) == "/" and result:sub(-1) ~= "/" then
				result = result .. "/"
			end

			return result
		end

		cwd = shorten_path(cwd)

		table.insert(cells, cwd)
		table.insert(cells, hostname)
	end

	-- Claude Code の状態をスキャンし、完了したものを通知する
	local agents = agent.scan()
	for _, done in ipairs(agent.take_completed()) do
		window:toast_notification("Claude Code", done.project .. " が完了しました", nil, 4000)
	end

	local running, total = agent.summary()
	if total > 0 then
		table.insert(cells, string.format("%s %d/%d", running > 0 and "🔵" or "⚫", running, total))
	end

	-- Get list of workspaces from the mux (no subprocess needed)
	local active_workspace = window:active_workspace()

	-- 実行中のエージェントを抱えているワークスペースには * を付ける
	local busy = {}
	for _, a in ipairs(agents) do
		if a.status == "running" then
			busy[a.workspace] = true
		end
	end

	local unique_workspaces = { [active_workspace] = true }
	for _, mux_win in ipairs(wezterm.mux.all_windows()) do
		unique_workspaces[mux_win:get_workspace()] = true
	end

	local workspaces = {}
	for ws in pairs(unique_workspaces) do
		table.insert(workspaces, ws)
	end
	table.sort(workspaces)

	-- Format workspace list with current workspace highlighted
	local workspace_list = {}
	for _, ws in ipairs(workspaces) do
		local label = busy[ws] and (ws .. "*") or ws
		if ws == active_workspace then
			label = "[" .. label .. "]"
		end
		table.insert(workspace_list, label)
	end

	table.insert(cells, table.concat(workspace_list, " | "))

	-- The powerline < symbol
	local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	local colors = {
		"#3c1361",
		"#52307c",
		"#663a82",
		"#7c5295",
		"#b491c8",
	}

	-- Foreground color for the text across the fade
	local text_fg = "#c0c0c0"

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	function push(text, is_last)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

local custom = require("/custom")
merge_config(config, custom)

-- and finally, return the configuration to wezterm
return config
