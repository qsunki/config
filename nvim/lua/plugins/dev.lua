return {
	{
		dir = "~/config/gtags.nvim",
		opts = {},
		keys = {
			{ "<leader>gd", "<cmd>GtagsDef<cr>", desc = "Gtags Definition" },
			{ "<leader>gr", "<cmd>GtagsRef<cr>", desc = "Gtags Reference" },
			{ "<leader>gs", "<cmd>Gtags<cr>", desc = "Gtags Search Symbol" },
			{ "<leader>gc", "<cmd>GtagsCursor<cr>", desc = "Gtags Cursor Symbol" },
		},
	}
}
