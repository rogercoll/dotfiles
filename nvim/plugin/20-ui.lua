local pack = require 'config.pack'

pack.add {
  pack.repo 'wellle/context.vim',
  pack.repo 'farmergreg/vim-lastplace',
  pack.repo 'christoomey/vim-tmux-navigator',
  pack.repo 'pacha/vem-tabline',
  pack.repo 'nvim-tree/nvim-web-devicons',
  pack.repo 'lewis6991/gitsigns.nvim',
  pack.repo 'tpope/vim-fugitive',
  pack.repo 'tpope/vim-rhubarb',
}

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}
