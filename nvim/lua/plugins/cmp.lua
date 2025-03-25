return {
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/cmp-buffer'},
	{'hrsh7th/cmp-path'},
	{'hrsh7th/cmp-cmdline'},
	{'petertriho/cmp-git'},

	{'hrsh7th/cmp-vsnip'},
	{'hrsh7th/vim-vsnip'},

	{
		'hrsh7th/nvim-cmp',
		config = function()
		local cmp = require'cmp'
		cmp.setup({
			snippet = {
			  -- REQUIRED - you must specify a snippet engine
			  expand = function(args)
				vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			  end,
			},
			window = {
			  -- completion = cmp.config.window.bordered(),
			  -- documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
			  ['<C-b>'] = cmp.mapping.scroll_docs(-2),
			  ['<C-f>'] = cmp.mapping.scroll_docs(2),
			  ['<C-Space>'] = cmp.mapping.complete(),
			  ['<C-e>'] = cmp.mapping.abort(),
			  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			sources = cmp.config.sources({
			  { name = 'nvim_lsp' },
			  { name = 'vsnip' }, -- For vsnip users.
			}, {
			  { name = 'buffer' },
			})
		  })

		  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
		  -- Set configuration for specific filetype.
		  cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources({
			  { name = 'git' },
			}, {
			  { name = 'buffer' },
			})
		 })
		 require("cmp_git").setup() 

		  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		  cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
			  { name = 'buffer' }
			}
		  })

		  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		  cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
			  { name = 'path' }
			}, {
			  { name = 'cmdline' }
			}),
			matching = { disallow_symbol_nonprefix_matching = false }
		  })

		  -- Set up lspconfig.
		  local capabilities = require('cmp_nvim_lsp').default_capabilities()

		  require('lspconfig')['rust_analyzer'].setup {capabilities = capabilities}
		  require('lspconfig')['clangd'].setup {capabilities = capabilities}
		  require('lspconfig')['cmake'].setup {capabilities = capabilities}
		  require('lspconfig')['pyright'].setup {capabilities = capabilities}
		  require('lspconfig')['jdtls'].setup {capabilities = capabilities}
		end
	},

	{
	  "nvim-treesitter/nvim-treesitter",
	  version = false, -- last release is way too old and doesn't work on Windows
	  build = ":TSUpdate",
	  event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
	  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
	  init = function(plugin)
		-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
		-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
		-- no longer trigger the **nvim-treesitter** module to be loaded in time.
		-- Luckily, the only things that those plugins need are the custom queries, which we make available
		-- during startup.
		require("lazy.core.loader").add_to_rtp(plugin)
		require("nvim-treesitter.query_predicates")
	  end,
	  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	  keys = {
		{ "<c-space>", desc = "Increment Selection" },
		{ "<bs>", desc = "Decrement Selection", mode = "x" },
	  },
	  opts_extend = { "ensure_installed" },
	  ---@type TSConfig
	  ---@diagnostic disable-next-line: missing-fields
	  opts = {
		highlight = { enable = true },
		indent = { enable = true },
		ensure_installed = {
		  "bash",
		  "c",
		  "diff",
		  "html",
		  "javascript",
		  "jsdoc",
		  "json",
		  "jsonc",
		  "lua",
		  "luadoc",
		  "luap",
		  "markdown",
		  "markdown_inline",
		  "printf",
		  "python",
		  "query",
		  "regex",
		  "toml",
		  "tsx",
		  "typescript",
		  "vim",
		  "vimdoc",
		  "xml",
		  "yaml",
		},
		incremental_selection = {
		  enable = true,
		  keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<C-space>",
			scope_incremental = false,
			node_decremental = "<bs>",
		  },
		},
		textobjects = {
		  move = {
			enable = true,
			goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
			goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
			goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
			goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
		  },
		},
	  },
	  ---@param opts TSConfig
	  config = function(_, opts)

		if type(opts.ensure_installed) == "table" then
		  opts.ensure_installed = LazyVimdedup(opts.ensure_installed)
		end
		require("nvim-treesitter.configs").setup(opts)
	  end,
	}
}
