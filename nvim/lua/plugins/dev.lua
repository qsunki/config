return {
	{
		dir = "~/config/gtags.nvim",
		opts = {},
		keys = {
			{ "<leader>gd", "<cmd>GtagsCword -d<cr>", desc = "Gtags Definition" },
			{ "<leader>gr", "<cmd>GtagsCword -r<cr>", desc = "Gtags Reference" },
			{ "<leader>gg", "<cmd>GtagsGrepCword<cr>", desc = "Gtags Grep Word" },
		},
	}
}
