return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<C-t>", mode = { "n", "t" }, desc = "Toggle terminal" },
			{
				"<Leader>tig",
				function()
					require("tig").toggle()
				end,
				desc = "tig",
			},
			{
				"<Leader>lzd",
				function()
					require("toggleterm.terminal").Terminal:new({ cmd = "lazydocker", direction = "float" }):toggle()
				end,
				desc = "lazydocker",
			},
		},
		opts = {
			size = vim.o.lines * 0.25,
			open_mapping = [[<c-t>]],
			direction = "horizontal",
			shell = "/opt/homebrew/bin/bash --login",
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)
			vim.keymap.set("t", "<F12>", [[<c-\><c-n>]], { noremap = true })
		end,
	},
}
