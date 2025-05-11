return {
	{
		'fedepujol/move.nvim',
		config = function()
			require("move").setup()
			local opts = { noremap = true, silent = true }
		end,
		keys = {
			{
				"<C-Down>",
				":MoveBlock(1)<CR>",
				mode = "v",
				desc = "Move Block Down"
			},
			{
				"<C-Up>",
				":MoveBlock(-1)<CR>",
				mode = "v",
				desc = "Move Block Up"
			},
			{
				"<C-Right>",
				">gv",
				mode = "v",
				desc = "Move Block Right"
			},
			{
				"<C-Left>",
				"<gv",
				mode = "v",
				desc = "Move Block Left"
			},
		}
	}
}
