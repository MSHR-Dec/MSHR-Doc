return {
  {
    "ibhagwan/fzf-lua",
    branch = "main",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Leader>grep", function() require("fzf-lua").grep() end,        desc = "fzf grep" },
      { "<Leader>find", function() require("fzf-lua").grep_curbuf() end, desc = "fzf find in buffer" },
      { "<Leader>file", function() require("fzf-lua").files() end,       desc = "fzf files" },
      { "<Leader>buf",  function() require("fzf-lua").buffers() end,     desc = "fzf buffers" },
    },
  },
}
