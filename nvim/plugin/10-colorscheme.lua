local pack = require 'config.pack'

pack.add {
  pack.repo 'sainnhe/everforest',
  pack.repo 'sainnhe/gruvbox-material',
  pack.repo 'rebelot/kanagawa.nvim',
}

vim.o.background = 'dark'
vim.g.everforest_background = 'hard'
vim.g.everforest_better_performance = 1
vim.cmd 'colorscheme gruvbox-material'
