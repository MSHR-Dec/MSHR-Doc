return {
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      colors = { bg = "#2B2B2B" },
      transparent_bg = true,
    },
    config = function(_, opts)
      require("dracula").setup(opts)
      vim.cmd.colorscheme("dracula")
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "dracula" } },
}
