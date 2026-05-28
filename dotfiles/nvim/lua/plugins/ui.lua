return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_c = {
        "%{fnamemodify(getcwd(),':~')}",
        "%f",
      }
      opts.sections.lualine_z = { { require("codecompanionstatus") } }
      return opts
    end,
  },

  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.offsets = {
        { filetype = "neo-tree",     text = "Files",                  text_align = "left" },
        { filetype = "vista_kind",   text = "structure" },
        { filetype = "codecompanion", text = "🤖 CodeCompanion 🤖" },
      }
      return opts
    end,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      local ok, dracula = pcall(require, "dracula")
      local colors = ok and dracula.colors() or {}
      require("scrollbar").setup({
        handle = { color = colors.visual },
        marks = {
          Search = { color = colors.yellow },
          Error  = { color = colors.red },
          Warn   = { color = colors.orange },
          Info   = { color = colors.green },
          Hint   = { color = colors.cyan },
          Misc   = { color = colors.purple },
        },
      })
    end,
  },

  { "ryanoasis/vim-devicons", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
