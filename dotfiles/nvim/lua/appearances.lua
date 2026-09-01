-- theme
require("dracula").setup({
  colors = { bg = "#2B2B2B" },
  transparent_bg = true,
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
  heading = { signs = { "󰫎" } },
})

-- nerdtree
vim.g.NERDTreeShowLineNumbers = 1
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 30
vim.g.NERDTreeIgnore = { '^node_modules$', '^sig$' }
vim.keymap.set("n", "<c-b>", "<cmd>NERDTreeToggle<cr>", { remap = true })
vim.api.nvim_set_hl(0, "NERDTreeDir", { ctermfg = 0, fg = "#C7ADFF" })
vim.api.nvim_create_autocmd("VimEnter", {
  nested = true,
  callback = function()
    if vim.fn.exists(":NERDTree") == 0 or vim.fn.argc() > 0 then return end
    vim.cmd("NERDTree")
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
        filetype = "nerdtree",
        -- 文字列で "%{...}" を渡すと NERDTreeWinSize に合わせて式ごと切り詰められ、
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
