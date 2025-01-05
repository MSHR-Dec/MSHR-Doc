-- mason.nvim
require("mason").setup()

-- mason-lspconfig.nvim
require("mason-lspconfig").setup{}
require("mason-lspconfig").setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {}
  end,
}

-- codecompanion.nvim
vim.cmd([[cab cc CodeCompanion]])
vim.api.nvim_set_keymap("n", "<Leader>chat", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Leader>chat", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "ollama",
    },
    inline = {
      adapter = "ollama",
    },
    agent = {
      adapter = "ollama",
    }
  },
  adapters = {
    ollama = function()
      return require("codecompanion.adapters").extend("ollama", {
        schema = {
          model = {
            default = "llama3.2",
          }
        }
      })
    end,
  },
  display = {
    chat = {
      window = {
        position = "right",
        width = 0.3,
      }
    }
  }
})

-- copilot.vim
require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
vim.keymap.set("i", "<C-l>", "<Plug>(copilot-accept-word)")
vim.g.copilot_no_tab_map = true

-- copilot-cmp
require("copilot_cmp").setup{}

-- CopilotChat.nvim
require("CopilotChat").setup({
  mappings = {
    reset = {
      normal = 'gl',
      insert = 'gl',
    },
  }
})

-- nvim-cmp
local cmp = require("cmp")

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    -- { name = "copilot" },
  }, {
    { name = "buffer" },
  })
}

-- cmp-cmdline
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" }
  }, {
    { name = "cmdline" }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- lspconfig
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").clangd.setup {
  capabilities = capabilities,
}
require("lspconfig").terraformls.setup({
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  on_attach = function(client, bufnr)
    require("lspkeymap").on_attach(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

-- vim-terraform
vim.g.terraform_fmt_on_save = 1

-- vista.vim
vim.g.vista_default_executive = "nvim_lsp"
vim.keymap.set("n", "<Leader>vt", "<cmd>Vista!!<cr>")
