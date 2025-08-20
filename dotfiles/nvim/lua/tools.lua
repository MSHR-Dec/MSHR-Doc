-- toggleterm.nvim
require("toggleterm").setup{
  size = vim.o.lines * 0.25,
  open_mapping = [[<c-t>]],
  direction = "horizontal",
  shell = "/bin/bash --login",
}
vim.keymap.set("t", "<F12>", [[<c-\><c-n>]], { noremap = true })
vim.keymap.set("n", "<Leader>tig", "<cmd>lua require(\"tig\").toggle()<cr>")
-- Requirement:
--  Set "fullscreen" to `gui.screenMode` in the config
--  see: https://github.com/jesseduffield/lazydocker/blob/master/docs/Config.md
vim.keymap.set("n", "<Leader>lzd", function()
  Terminal  = require("toggleterm.terminal").Terminal:new({
    cmd = "lazydocker", direction = "float",
  }):toggle()
end)

-- fzf-lua
vim.keymap.set("n", "<Leader>grep", require("fzf-lua").grep)
vim.keymap.set("n", "<Leader>find", require("fzf-lua").grep_curbuf)
vim.keymap.set("n", "<Leader>file", require("fzf-lua").files)
vim.keymap.set("n", "<Leader>buf", require("fzf-lua").buffers)

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
vim.api.nvim_set_keymap("n", "<leader>r", "<CMD>SearchReplaceSingleBufferOpen<CR>", {})
vim.api.nvim_set_keymap("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", {})
