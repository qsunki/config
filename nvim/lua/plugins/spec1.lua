return {
	{
		"dhananjaylatkar/cscope_maps.nvim",
		dependencies = {
			"ibhagwan/fzf-lua"
		},
		opts = {
			skip_input_prompt = true,
			cscope = {
				exec = "gtags-cscope",
				picker = "fzf-lua",
				skip_picker_for_single_result = true,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = 'master',
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true },
			})
		end,
	},
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		lazy = false,
		priority = 1000
	},
}
