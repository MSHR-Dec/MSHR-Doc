return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      local kill = {
        "K", "gd", "gD", "gr", "gI", "gy",
        "<leader>ca", "<leader>cr", "<leader>cf", "<leader>cd",
        "]d", "[d", "]e", "[e", "]w", "[w",
      }
      for i = #keys, 1, -1 do
        for _, lhs in ipairs(kill) do
          if keys[i][1] == lhs then
            table.remove(keys, i)
            break
          end
        end
      end
      vim.list_extend(keys, {
        { "gh", vim.lsp.buf.hover,                                       desc = "Hover" },
        { "gf", function() vim.lsp.buf.format({ async = true }) end,     desc = "Format" },
        { "gr", vim.lsp.buf.references,                                  desc = "References" },
        { "gd", vim.lsp.buf.definition,                                  desc = "Definition" },
        { "gD", vim.lsp.buf.declaration,                                 desc = "Declaration" },
        { "gi", vim.lsp.buf.implementation,                              desc = "Implementation" },
        { "gy", vim.lsp.buf.type_definition,                             desc = "Type Definition" },
        { "gn", vim.lsp.buf.rename,                                      desc = "Rename" },
        { "ga", vim.lsp.buf.code_action,                                 desc = "Code Action", mode = { "n", "v" } },
        { "ge", vim.diagnostic.open_float,                               desc = "Line Diagnostics" },
        { "g]", vim.diagnostic.goto_next,                                desc = "Next Diagnostic" },
        { "g[", vim.diagnostic.goto_prev,                                desc = "Prev Diagnostic" },
      })

      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, {
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
