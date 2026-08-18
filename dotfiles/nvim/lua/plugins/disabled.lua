return {
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim",       enabled = false },

  -- LSP 一式を無効化（重い / エラーが出るため）
  -- 戻すときはこの 3 行を消すだけ。plugins/lsp.lua と plugins/ruby.lua の
  -- 設定はそのまま残してあるので、削除後は元の状態に復帰します。
  { "neovim/nvim-lspconfig",          enabled = false },
  { "mason-org/mason.nvim",           enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
}
