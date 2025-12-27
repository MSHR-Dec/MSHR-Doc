vim.lsp.config.gopls = ({
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  on_attach = function(client, bufnr)
    require("lspkeymap").on_attach(client, bufnr)
  end,
})
