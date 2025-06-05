return {
	{
		'numToStr/Comment.nvim',
		opts = {
			toggler = {
				line = '<C-/>',
				block = 'gbc',
			},
			leader = {
				line = 'gc',
				block = 'gb',
			},
			mappings = {
				basic = true,
				extra = false,
			},
		}
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require('todo-comments').setup()
		end
	},
}
