-- Disable LazyVim defaults that conflict with our scheme.
-- LazyVim binds these on VeryLazy, so we delete them inside a VeryLazy autocmd.
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local del = function(mode, lhs) pcall(vim.keymap.del, mode, lhs) end
    del("n", "<S-h>")
    del("n", "<S-l>")
    del("n", "[b")
    del("n", "]b")
  end,
})

-- Cursor / register behaviour
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("n", "s", "\"_s")

-- Buffer navigation
vim.keymap.set("n", "<c-n>", "<cmd>bnext<cr>", { remap = true })
vim.keymap.set("n", "<c-p>", "<cmd>bprev<cr>", { remap = true })

-- Leader misc
vim.keymap.set("n", "<Leader>;", "<cmd>nohlsearch<cr>", { remap = true })
vim.keymap.set("n", "<Leader>jq", "<cmd>%!jq '.'<cr><ecs>", { remap = true })
vim.keymap.set("n", "<Leader>vs", "<cmd>vsplit<cr><C-w>w<cr>", { remap = true })
vim.keymap.set("n", "<Leader>nu", "<cmd>set number!<CR>")
vim.keymap.set("n", "<Esc><Esc>", "<Cmd>nohlsearch<CR><Esc>", { noremap = true, silent = true })

-- Window navigation
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")

-- Window resize
vim.keymap.set("n", "<c-up>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<c-down>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<c-left>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<c-right>", "<cmd>vertical resize +2<cr>")
vim.keymap.set("t", "<c-up>", "<cmd>resize -2<cr>")
vim.keymap.set("t", "<c-down>", "<cmd>resize +2<cr>")
vim.keymap.set("t", "<c-left>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("t", "<c-right>", "<cmd>vertical resize +2<cr>")
vim.keymap.set("t", "<c-j>", "<cmd>wincmd j<cr>")
vim.keymap.set("t", "<c-k>", "<cmd>wincmd k<cr>")

-- Visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
