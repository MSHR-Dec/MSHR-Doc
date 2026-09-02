-- toggleterm.nvim
local login_shell = vim.fn.executable("/opt/homebrew/bin/bash") == 1
  and "/opt/homebrew/bin/brush --login"
  or "/bin/bash --login"

require("toggleterm").setup({
  size = vim.o.lines * 0.25,
  open_mapping = [[<c-t>]],
  direction = "horizontal",
  shell = login_shell,
})
vim.keymap.set("t", "<F12>", [[<c-\><c-n>]], { noremap = true })
vim.keymap.set("n", "<Leader>tig", function() require("tig").toggle() end)
-- Requirement:
--  Set "fullscreen" to `gui.screenMode` in the config
--  see: https://github.com/jesseduffield/lazydocker/blob/master/docs/Config.md
vim.keymap.set("n", "<Leader>lzd", function()
  require("toggleterm.terminal").Terminal:new({
    cmd = "lazydocker", direction = "float",
  }):toggle()
end)

vim.keymap.set("n", "<Leader>gg", function() require("telescope.builtin").live_grep() end)
vim.keymap.set("n", "<Leader>gf", function() require("telescope.builtin").current_buffer_fuzzy_find() end)
vim.keymap.set("n", "<Leader>gF", function() require("telescope.builtin").find_files() end)
vim.keymap.set("n", "<Leader>gb", function() require("telescope.builtin").buffers() end)

-- nb (https://xwmx.github.io/nb/)
-- nb の起動が重いのでノートブックのパスは解決せずに組み立てる
local nb = { notebook = "memo" }
nb.dir = (vim.env.NB_DIR or vim.fn.expand("~/.nb")) .. "/" .. nb.notebook

-- <Leader>nn のフォルダ補完（v:lua から参照するのでグローバルに置く）
_G.NbFolderComplete = function(arg)
  local candidates = {}
  for name, kind in vim.fs.dir(nb.dir, {
    depth = 4,
    skip = function(dir) return not vim.startswith(dir, ".") end,
  }) do
    if kind == "directory" and not vim.startswith(name, ".") then
      local folder = name .. "/"
      if folder ~= arg and vim.startswith(folder, arg) then
        table.insert(candidates, folder)
      end
    end
  end
  table.sort(candidates)
  return candidates
end

-- nb はパイプ越しでも色を付けるので、通知やパースの前に落とす
local function nb_run(args, input)
  local out = input and vim.fn.system(args, input) or vim.fn.system(args)
  out = vim.trim((out:gsub("\27%[[%d;]*m", ""):gsub("\27%([AB0]", "")))
  if vim.v.shell_error ~= 0 then
    vim.notify(out, vim.log.levels.ERROR)
    return nil
  end
  return out
end

local function nb_new()
  local opts = { prompt = "Memo path: ", completion = "customlist,v:lua.NbFolderComplete" }
  vim.ui.input(opts, function(input)
    if not input or input == "" then return end
    -- "work/tech/タイトル" → フォルダとタイトルに分解する（中間フォルダは nb が自動生成）
    local folder, title = input:match("^(.*)/([^/]+)$")
    local args = { "nb", nb.notebook .. ":add", "--title", title or input }
    if folder and folder ~= "" then
      vim.list_extend(args, { "--folder", folder })
    end
    -- 空の stdin を渡すと nb は $EDITOR を起動せずに作成する
    -- （--content "" は「空文字は不正な引数」として弾かれる）
    local added = nb_run(args, "")
    if not added then return end
    -- Added: [memo:work/tech/1] memo:work/tech/kafka_setup.md "Kafka Setup"
    local selector = added:match("%[(.-)%]")
    if not selector then
      vim.notify("nb: failed to parse selector from: " .. added, vim.log.levels.ERROR)
      return
    end
    local path = nb_run({ "nb", "show", selector, "--path" })
    if not path then return end
    vim.cmd.edit(vim.fn.fnameescape(path))
  end)
end

vim.keymap.set("n", "<Leader>nn", nb_new, { noremap = true, desc = "nb: new note" })
vim.keymap.set("n", "<Leader>nl", function()
  require("telescope.builtin").find_files({ prompt_title = "Memo", cwd = nb.dir })
end, { noremap = true, desc = "nb: list notes" })
vim.keymap.set("n", "<Leader>ng", function()
  require("telescope.builtin").live_grep({ prompt_title = "Memo Grep", cwd = nb.dir })
end, { noremap = true, desc = "nb: grep notes" })

-- nvim から直接保存した分は nb 経由でないためコミットされない
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = nb.dir .. "/*",
  callback = function()
    vim.system({ "nb", "git", "checkpoint" }, { cwd = nb.dir })
  end,
})

-- search-replace
require("search-replace").setup({
  default_replace_single_buffer_options = "gcI",
  default_replace_multi_buffer_options = "egcI",
})
vim.keymap.set("n", "<Leader>r", "<cmd>SearchReplaceSingleBufferOpen<cr>")
vim.keymap.set("v", "<C-r>", "<cmd>SearchReplaceSingleBufferVisualSelection<cr>")

-- vim-terraform
vim.g.terraform_fmt_on_save = 1
