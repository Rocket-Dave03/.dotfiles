return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
  	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
		  -- load the colorscheme here
		  vim.cmd([[colorscheme tokyonight]])
		end,
  	},
	{ "arcticicestudio/nord-vim" },
	{ "frazrepo/vim-rainbow" },
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},

	{
        "3rd/image.nvim",
		build = false,
        opts = {},
		config = function()
			require("image").setup({
				processor = "magick_cli",
				 integrations = {
					markdown = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = true,
						floating_windows = false, -- if true, images will be rendered in floating markdown windows
						filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
						resolve_image_path = function(document_path, image_path, fallback)
							github = "https://github.com/"
							if (string.starts(image_path, github)) then
								image_path = string.sub(image_path, string.len(github),-1)

								split_idx = string.find(image_path, "blob")
								userrepo = string.sub(image_path, 1,split_idx-1)
								blob = "/blob/"
								rest = string.sub(image_path, split_idx+(string.len(blob)-1),-1)
								return "http://raw.githubusercontent.com" .. userrepo .. "refs/heads/" .. rest
							end
							fallback(document_path, image_path)
						end
					},
				},
			}) 
		end
    },
}
