return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			on_attach = function(buffer)
				local gs = require("gitsigns")
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
				end
				map("n", "ghs", gs.stage_hunk, "Stage hunk")
				map("n", "ghu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "ghp", gs.preview_hunk, "Preview hunk")
			end,
		},
	},

	{
		"roobert/search-replace.nvim",
		keys = {
			{ "<leader>r", "<cmd>SearchReplaceSingleBufferOpen<cr>", mode = "n" },
			{ "<C-r>", "<cmd>SearchReplaceSingleBufferVisualSelection<cr>", mode = "v" },
		},
		opts = {
			default_replace_single_buffer_options = "gcI",
			default_replace_multi_buffer_options = "egcI",
		},
	},

	{
		"glidenote/memolist.vim",
		cmd = { "MemoNew", "MemoList", "MemoGrep" },
		keys = {
			{ "<Leader>mn", "<cmd>MemoNew<cr>" },
			{ "<Leader>ml", "<cmd>MemoList<cr>" },
			{ "<Leader>mg", "<cmd>MemoGrep<cr>" },
		},
		init = function()
			vim.g.memolist_path = "$HOME/.memo"
		end,
	},

	-- {
	--   "liuchengxu/vista.vim",
	--   cmd = { "Vista" },
	--   keys = { { "<Leader>vt", "<cmd>Vista!!<cr>" } },
	--   init = function()
	--     vim.g.vista_default_executive = "nvim_lsp"
	--   end,
	-- },

	{ "tpope/vim-fugitive", cmd = { "G", "Git", "Gdiff", "Gblame", "Glog" } },

	-- Avoid indent-blankline + mini.indentscope overlap.
	{ "nvim-mini/mini.indentscope", enabled = false },
}
