return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults = opts.defaults or {}
      opts.defaults.file_ignore_patterns = { "node_modules", "sig" }
      return opts
    end,
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Telescope live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Telescope buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Telescope help tags" },
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}
