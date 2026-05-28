return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<C-b>", "<cmd>Neotree toggle<cr>", desc = "Explorer (neo-tree)" },
    },
    opts = {
      window = { width = 35 },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        callback = function()
          vim.opt_local.number = true
        end,
      })
    end,
  },
}
