-- vim.g.vista_executive_for = {
--   ruby = "coc"
-- }
-- vim.g.coc_user_config = {
--   ["solargraph.shell"] = "/bin/zsh",
-- }

local lspconfig = require('lspconfig')
lspconfig.ruby_lsp.setup({
  init_options = {
    formatter = 'standard',
    linters = { 'standard' },
  },
  on_attach = function(client, bufnr)
    require("lspkeymap").on_attach(client, bufnr)
  end,
  cmd = { "/home/ubuntu/.rbenv/shims/ruby-lsp"},
})
