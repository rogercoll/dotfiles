
-- Autoload bash skeleton
vim.api.nvim_command('autocmd BufNewFile *.sh 0r ~/.config/nvim/skeletons/bash.sh')

-- Detect markdown
vim.api.nvim_command('autocmd BufRead *.md set filetype=markdown')
