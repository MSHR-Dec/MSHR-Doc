-- theme
require("dracula").setup({
  colors = { bg = "#2B2B2B" },
  transparent_bg = true,
})
vim.cmd.colorscheme('dracula')

-- nvim-treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "go", "hcl", "terraform", "lua", "vim", "vimdoc",
    "json", "yaml", "markdown", "markdown_inline",
  },
  highlight = { enable = true },
})

-- nerdtree
vim.g.NERDTreeShowLineNumbers = 1
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 35
vim.g.NERDTreeIgnore = { '^node_modules$', '^sig$' }
vim.keymap.set("n", "<c-b>", "<cmd>NERDTreeToggle<cr>", { remap = true })
vim.api.nvim_set_hl(0, "NERDTreeDir", { ctermfg = 0, fg = "#C7ADFF" })

-- lualine.nvim
require("lualine").setup({
  sections = {
    lualine_c = {
      "%{fnamemodify(getcwd(),':~')}",
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
        text = "%{fnamemodify(getcwd(),':~')}",
        text_align = "left",
      },
    },
  },
})

-- gitsigns.nvim
require("gitsigns").setup({
  preview_config = { border = "rounded" },
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local map = function(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr })
    end
    -- gitsigns v1.0 以降 stage_hunk は toggle 動作（undo_stage_hunk は非推奨）
    map("ghs", gs.stage_hunk)
    map("ghu", gs.undo_stage_hunk or gs.stage_hunk)
    map("ghp", gs.preview_hunk)
  end,
})

-- indentmini.nvim
vim.cmd.highlight("IndentLine guifg=#767676")
vim.cmd.highlight("IndentLineCurrent guifg=#af00ff")
require("indentmini").setup()
