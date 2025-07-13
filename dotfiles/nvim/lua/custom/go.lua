require("lspconfig").gopls.setup({
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  on_attach = function(client, bufnr)
    require("lspkeymap").on_attach(client, bufnr)
  end,
})
