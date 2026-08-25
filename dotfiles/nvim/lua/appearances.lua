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

-- Neovim 0.12 系のバグ回避: markdown の highlights クエリにある
-- `(#set! conceal_lines "")` が languagetree.lua の parse 中に
-- `attempt to call method 'range' (a nil value)` でクラッシュする
-- (https://github.com/neovim/neovim/issues/39032)。
-- conceal_lines の設定だけを取り除いたクエリで上書きする。
vim.treesitter.query.set("markdown", "highlights", [[
;From MDeiml/tree-sitter-markdown & Helix
(setext_heading
  (paragraph) @markup.heading.1
  (setext_h1_underline) @markup.heading.1)

(setext_heading
  (paragraph) @markup.heading.2
  (setext_h2_underline) @markup.heading.2)

(atx_heading
  (atx_h1_marker)) @markup.heading.1

(atx_heading
  (atx_h2_marker)) @markup.heading.2

(atx_heading
  (atx_h3_marker)) @markup.heading.3

(atx_heading
  (atx_h4_marker)) @markup.heading.4

(atx_heading
  (atx_h5_marker)) @markup.heading.5

(atx_heading
  (atx_h6_marker)) @markup.heading.6

(info_string) @label

(pipe_table_header
  (pipe_table_cell) @markup.heading)

(pipe_table_header
  "|" @punctuation.special)

(pipe_table_row
  "|" @punctuation.special)

(pipe_table_delimiter_row
  "|" @punctuation.special)

(pipe_table_delimiter_cell) @punctuation.special

; Code blocks (conceal backticks and language annotation)
(indented_code_block) @markup.raw.block

((fenced_code_block) @markup.raw.block
  (#set! priority 90))

(fenced_code_block
  (fenced_code_block_delimiter) @markup.raw.block
  (#set! conceal ""))

(fenced_code_block
  (info_string
    (language) @label
    (#set! conceal "")))

(link_destination) @markup.link.url

[
  (link_title)
  (link_label)
] @markup.link.label

((link_label)
  .
  ":" @punctuation.delimiter)

[
  (list_marker_plus)
  (list_marker_minus)
  (list_marker_star)
  (list_marker_dot)
  (list_marker_parenthesis)
] @markup.list

(thematic_break) @punctuation.special

(task_list_marker_unchecked) @markup.list.unchecked

(task_list_marker_checked) @markup.list.checked

((block_quote) @markup.quote
  (#set! priority 90))

([
  (plus_metadata)
  (minus_metadata)
] @keyword.directive
  (#set! priority 90))

[
  (block_continuation)
  (block_quote_marker)
] @punctuation.special

(backslash_escape) @string.escape

(inline) @spell
]])

-- nerdtree
vim.g.NERDTreeShowLineNumbers = 1
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 30
vim.g.NERDTreeIgnore = { '^node_modules$', '^sig$' }
vim.keymap.set("n", "<c-b>", "<cmd>NERDTreeToggle<cr>", { remap = true })
vim.api.nvim_set_hl(0, "NERDTreeDir", { ctermfg = 0, fg = "#C7ADFF" })

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
