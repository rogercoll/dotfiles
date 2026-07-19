local pack = require 'config.pack'

pack.add {
  pack.repo 'windwp/nvim-autopairs',
  pack.repo 'numToStr/Comment.nvim',
  pack.repo 'tpope/vim-sleuth',
  pack.repo 'folke/which-key.nvim',
  pack.repo 'wakatime/vim-wakatime',
}

require('nvim-autopairs').setup {
  fast_wrap = {},
  disable_filetype = { 'TelescopePrompt', 'vim' },
}

require('Comment').setup()

require('which-key').setup()
require('which-key').add {
  { '<leader>c', desc = '[C]ode' },
  { '<leader>d', desc = '[D]ocument' },
  { '<leader>r', desc = '[R]ename' },
  { '<leader>s', desc = '[S]earch' },
  { '<leader>w', desc = '[W]orkspace' },
}
