return {
	-- NOTE: Place visible line in loops to keep the context: https://github.com/wellle/context.vim
	-- WARN: validate performance, might be low
	{ "wellle/context.vim" },

	-- NOTE: Place cursor to last edited line
	{ "farmergreg/vim-lastplace" },

	-- NOTE: Tmux ctrl navigation.
	{ "christoomey/vim-tmux-navigator" },

	-- NOTE: Tab line (simple)
	{ "pacha/vem-tabline" },
	-- NOTE: Tab line with jump mode
	-- { "romgrk/barbar.nvim" },

	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{
		"tpope/vim-fugitive",
		dependencies = {
			"tpope/vim-rhubarb", -- NOTE: GitHub extension for fugitive.vim
		},
	},

	-- NOTE: Plugins can also be added by using a table,
	-- with the first argument being the link and the following
	-- keys can be used to configure plugin behavior/loading/etc.
	--
	-- Use `opts = {}` to force a plugin to be loaded.
	--
	--  This is equivalent to:
	--    require('Comment').setup({})

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	-- Here is a more advanced example where we pass configuration
	-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
	--    require('gitsigns').setup({ ... })
	--
	-- See `:help gitsigns` to understand what the configuration keys do
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
}
