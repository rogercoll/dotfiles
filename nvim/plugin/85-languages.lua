local pack = require 'config.pack'

pack.add {
  pack.repo 'fatih/vim-go',
  pack.repo 'tyru/open-browser.vim',
  pack.repo 'rogercoll/open-browser-rustdoc.vim',
  pack.repo 'mrcjkb/haskell-tools.nvim',
}

vim.g.go_fmt_autosave = 1
vim.g.go_fmt_experimental = 1
vim.g.go_fmt_command = 'goimports'
