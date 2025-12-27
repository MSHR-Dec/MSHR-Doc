-- theme
require("dracula").setup({
  colors = {
    bg = "#1b2738",
  }
})
vim.cmd.colorscheme('dracula')

-- nvim-treesitter
require"nvim-treesitter".setup {
  ensure_installed = { "go", "hcl", "lua", "vim", "vimdoc", "json", "yaml", "markdown", "markdown_inline" },
  highlight = {
    enable = true,
  },
}

-- nerdtree
vim.g.NERDTreeShowLineNumbers = 1
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 35
vim.keymap.set("n", "<c-b>", "<cmd>NERDTreeToggle<cr>", { remap = true })
vim.api.nvim_set_hl(0, "NERDTreeDir", { ctermfg = 0, fg = "#C7ADFF" })

-- lualine.nvim
require("lualine").setup({
  sections = {
    lualine_c = {
      "%{fnamemodify(getcwd(),':~')}",
      "%f",
    },
    lualine_z = {
      { require("codecompanionstatus") },
    }
  }
})

-- nvim-scrollbar
local colors = require("dracula").colors()
require("scrollbar").setup({
  handle = {
    color = colors.visual,
  },
  marks = {
    Search = { color = colors.yellow },
    Error = { color = colors.red },
    Warn = { color = colors.orange },
    Info = { color = colors.green },
    Hint = { color = colors.cyan },
    Misc = { color = colors.purple },
  }
})

-- bufferline.nvim
vim.opt.termguicolors = true
require("bufferline").setup({
  options = {
    offsets = {
--       {
--         filetype = "nerdtree",
--         text = "%{fnamemodify(getcwd(),':~')}",
--         text_align = "left",
--       },
      {
        filetype = "vista_kind",
        text = "structure",
      },
      {
        filetype = "codecompanion",
        text = "🤖 CodeCompanion 🤖",
      }
    },
  }
})

-- vim-gitgutter
vim.g.gitgutter_preview_win_floating = 1
vim.keymap.set("n", "ghs", "<Plug>(GitGutterStageHunk)")
vim.keymap.set("n", "ghu", "<Plug>(GitGutterUndoHunk)")
vim.keymap.set("n", "ghp", "<Plug>(GitGutterPreviewHunk)")

-- indentmini.nvim
vim.cmd.highlight("IndentLine guifg=#767676")
vim.cmd.highlight("IndentLineCurrent guifg=#af00ff")
require("indentmini").setup()
