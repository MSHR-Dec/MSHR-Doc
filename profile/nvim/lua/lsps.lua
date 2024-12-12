-- mason.nvim
require("mason").setup()

-- mason-lspconfig.nvim
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {}
  end,
}

-- nvim-cmp
local cmp = require("cmp")
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" }
  })
}

-- lspconfig
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").clangd.setup {
  capabilities = capabilities,
}
require("lspconfig").terraformls.setup({
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})


-- vim-terraform
vim.g.terraform_fmt_on_save = 1
