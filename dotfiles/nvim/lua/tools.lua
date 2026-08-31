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

-- fzf-lua
vim.keymap.set("n", "<Leader>gg", function() require("fzf-lua").grep() end)
vim.keymap.set("n", "<Leader>gf", function() require("fzf-lua").grep_curbuf() end)
vim.keymap.set("n", "<Leader>gF", function() require("fzf-lua").files() end)
vim.keymap.set("n", "<Leader>gb", function() require("fzf-lua").buffers() end)

-- memolist.vim
vim.g.memolist_path = "$HOME/.memo"
vim.keymap.set("n", "<Leader>mn", "<cmd>MemoNew<cr>", { noremap = true })
vim.keymap.set("n", "<Leader>ml", "<cmd>MemoList<cr>", { noremap = true })
vim.keymap.set("n", "<Leader>mg", "<cmd>MemoGrep<cr>", { noremap = true })

-- search-replace
require("search-replace").setup({
  default_replace_single_buffer_options = "gcI",
  default_replace_multi_buffer_options = "egcI",
})
vim.keymap.set("n", "<Leader>r", "<cmd>SearchReplaceSingleBufferOpen<cr>")
vim.keymap.set("v", "<C-r>", "<cmd>SearchReplaceSingleBufferVisualSelection<cr>")

-- vim-terraform
vim.g.terraform_fmt_on_save = 1
