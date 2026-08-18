return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
        ["*"] = {
          keys = {
            { "K", false },
            { "gI", false },
            { "<leader>ca", false },
            { "<leader>cr", false },
            { "<leader>cf", false },
            { "<leader>cd", false },
            { "]d", false },
            { "[d", false },
            { "]e", false },
            { "[e", false },
            { "]w", false },
            { "[w", false },

            { "gh", vim.lsp.buf.hover,                                   desc = "Hover" },
            { "gf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format" },
            { "gr", vim.lsp.buf.references,                              desc = "References" },
            { "gd", vim.lsp.buf.definition,                              desc = "Definition" },
            { "gD", vim.lsp.buf.declaration,                             desc = "Declaration" },
            { "gi", vim.lsp.buf.implementation,                          desc = "Implementation" },
            { "gy", vim.lsp.buf.type_definition,                         desc = "Type Definition" },
            { "gn", vim.lsp.buf.rename,                                  desc = "Rename" },
            { "ga", vim.lsp.buf.code_action,                             desc = "Code Action", mode = { "n", "v" } },
            { "ge", vim.diagnostic.open_float,                           desc = "Line Diagnostics" },
            { "g]", vim.diagnostic.goto_next,                            desc = "Next Diagnostic" },
            { "g[", vim.diagnostic.goto_prev,                            desc = "Prev Diagnostic" },
          },
        },
        clangd = {},
        terraform_ls = {
          cmd = { "terraform-ls" },
          filetypes = { "terraform", "tf" },
        },
      })

      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = false,
        underline = true,
      })

      return opts
    end,
  },
}
