-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Files and tabs helpers
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.0',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'nvim-tree/nvim-web-devicons'
  use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}

  -- Highlight yanked region
  use 'machakann/vim-highlightedyank'

  -- Trailing spaces
  use 'ntpeters/vim-better-whitespace'

  -- Colorscheme
  use {
    'navarasu/onedark.nvim',
    lazy = false,
    config = function()
      require('onedark').setup({ style = 'warmer' })
      require('onedark').load()
    end,
  }

  -- Syntactic language support
  use 'cespare/vim-toml'
  use 'stephpy/vim-yaml'
  use 'rust-lang/rust.vim'
  use 'fatih/vim-go'
  use 'godlygeek/tabular'
  use 'plasticboy/vim-markdown'
  use 'tpope/vim-commentary'

  use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use ('nvim-treesitter/playground')
  use ('eckon/treesitter-current-functions')
  use ('mbbill/undotree')
  use ('tpope/vim-fugitive')

  -- LSP plugins
  use {
	  'VonHeikemen/lsp-zero.nvim',
	  requires = {
	    -- LSP Support
	    {'neovim/nvim-lspconfig'},
	    {'williamboman/mason.nvim'},
	    {'williamboman/mason-lspconfig.nvim'},

	    -- Autocompletion
	    {'hrsh7th/nvim-cmp'},
	    {'hrsh7th/cmp-buffer'},
	    {'hrsh7th/cmp-path'},
	    {'saadparwaiz1/cmp_luasnip'},
	    {'hrsh7th/cmp-nvim-lsp'},
	    {'hrsh7th/cmp-nvim-lua'},

	    -- Snippets
	    {'L3MON4D3/LuaSnip'},
	    {'rafamadriz/friendly-snippets'},
  }
}

end)
