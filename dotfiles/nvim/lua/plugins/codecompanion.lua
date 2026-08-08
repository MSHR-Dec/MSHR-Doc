return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    keys = {
      { "<Leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion chat" },
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
    end,
    opts = {
      strategies = {
        chat   = { adapter = "copilot" },
        inline = { adapter = "copilot" },
      },
      display = {
        chat = {
          window = {
            position = "right",
            width = 0.3,
          },
        },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = { "CopilotChat", "CopilotChatToggle" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
