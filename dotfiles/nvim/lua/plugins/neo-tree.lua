return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = false,
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
					never_show = {
						"node_modules",
						".git",
						"sig",
					},
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
