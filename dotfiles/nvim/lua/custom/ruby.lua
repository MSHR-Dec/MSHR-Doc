require("lspconfig").ruby_lsp.setup({
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  init_options = {
    formatter = 'standard',
    linters = { 'standard' },
  },
  cmd = { vim.env.HOME .. '/.rbenv/shims/ruby-lsp' },
  on_attach = function(client, bufnr)
    require("lspkeymap").on_attach(client, bufnr)
  end,
})
