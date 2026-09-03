-- theme
require("dracula").setup({
  colors = { bg = "#2B2B2B" },
  transparent_bg = true,
  overrides = {
    Visual   = { bg = "#574778" },
    VisualNOS = { bg = "#574778" },
  },
})
vim.cmd.colorscheme('dracula')

-- nvim-treesitter (main ブランチ)
require("nvim-treesitter").install({
  "go", "hcl", "terraform", "lua", "vim", "vimdoc",
  "json", "yaml", "markdown", "markdown_inline",
})
vim.api.nvim_create_autocmd("FileType", {
  -- パーサ名ではなく filetype で指定する (vimdoc -> help)
  pattern = {
    "go", "hcl", "terraform", "lua", "vim", "help",
    "json", "yaml", "markdown",
  },
  callback = function() vim.treesitter.start() end,
})

-- render-markdown.nvim
-- ambiwidth=double だと既定の見出しサイン '󰫎 ' が3セル幅になり
-- nvim_buf_set_extmark が Invalid 'sign_text' で失敗するため末尾スペースを外す
require("render-markdown").setup({
  heading = {
    sign = true,
    signs = { "󰫎" },
    icons = {},
    width = 'block',
    backgrounds = {},
  },
  bullet = { icons = '•' },
})

-- 言語指定のないコードブロックを 'plain' として描画する
-- render-markdown は info_string ノードが無いと言語行を描画しないため
-- (render/markdown/code.lua の Render:language が早期 return する)
-- 疑似の info/language ノードを注入して既定の描画経路に乗せる
local ok_devicons, devicons = pcall(require, 'nvim-web-devicons')
if ok_devicons then
  devicons.set_icon_by_filetype({ plain = 'txt' })
end

local ok_code, code = pcall(require, 'render-markdown.render.markdown.code')
if ok_code then
  local code_setup = code.setup
  code.setup = function(self)
    local enabled = code_setup(self)
    if enabled and not self.data.language then
      local delim = self.node:child('fenced_code_block_delimiter', self.node.start_row)
      if delim then
        local pos = {
          start_row = delim.start_row, start_col = delim.end_col,
          end_row = delim.start_row, end_col = delim.end_col,
        }
        self.data.info = vim.tbl_extend('force', pos, { text = '' })
        self.data.language = vim.tbl_extend('force', pos, { text = 'plain' })
      end
    end
    return enabled
  end
end

-- neo-tree.nvim
require("neo-tree").setup({
  close_if_last_window = true,
  window = { width = 30 },
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_by_name = { "node_modules", "sig" },
    },
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
  },
  event_handlers = {
    {
      -- 行番号を出すオプションが setup に無いため、
      -- ツリーのバッファに入った時点でウィンドウローカルに設定する
      event = "neo_tree_buffer_enter",
      handler = function() vim.wo.number = true end,
    },
  },
})
vim.keymap.set("n", "<c-b>", "<cmd>Neotree toggle<cr>", { remap = true })
vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#C7ADFF" })
vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#C7ADFF" })
vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    if vim.fn.exists(":Neotree") == 0 or vim.fn.argc() > 0 then return end
    vim.cmd("Neotree show")
  end,
})

-- lualine.nvim
require("lualine").setup({
  sections = {
    lualine_c = {
      function() return vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end,
      "%f",
    },
  },
})

-- nvim-scrollbar
local colors = require("dracula").colors()
require("scrollbar").setup({
  handle = { color = colors.visual },
  marks = {
    Search = { color = colors.yellow },
    Error  = { color = colors.red },
    Warn   = { color = colors.orange },
    Info   = { color = colors.green },
    Hint   = { color = colors.cyan },
    Misc   = { color = colors.purple },
  },
})

-- bufferline.nvim
require("bufferline").setup({
  options = {
    offsets = {
      {
        filetype = "neo-tree",
        -- 文字列で "%{...}" を渡すとツリーの幅に合わせて式ごと切り詰められ、
        -- 閉じない %{ が tabline を壊すため関数で評価済みの文字列を返す
        text = function() return vim.fn.fnamemodify(vim.fn.getcwd(), ":~") end,
        text_align = "left",
      },
    },
  },
})
vim.keymap.set("n", "<Leader>w", function()
  local buf = vim.api.nvim_get_current_buf()
  -- bdelete はウィンドウごと閉じてしまうため、先に隣のバッファへ移ってから削除する
  vim.cmd("BufferLineCycleNext")
  if vim.api.nvim_get_current_buf() == buf then
    vim.cmd("enew") -- 最後の1枚なら空バッファへ退避
  end
  vim.api.nvim_buf_delete(buf, { force = false })
end, { desc = "Close current buffer (keep window)" })

-- vim-gitgutter, vim-fugitive
vim.g.gitgutter_preview_win_floating = 1
vim.keymap.set("n", "ghu", "<Plug>(GitGutterUndoHunk)")
vim.keymap.set("n", "ghp", "<Plug>(GitGutterPreviewHunk)")

-- indentmini.nvim
vim.cmd.highlight("IndentLine guifg=#767676")
vim.cmd.highlight("IndentLineCurrent guifg=#af00ff")
require("indentmini").setup()
