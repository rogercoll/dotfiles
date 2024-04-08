-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto remove trailing spaces
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  command = [[%s/\s\+$//e]],
})

-- Golang keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  callback = function()
    vim.schedule(function()
      vim.keymap.set('n', '<leader>re', 'oif err != err {<CR>}<ESC>Oreturn err<ESC>')
      -- TODO: Add more keymaps here
    end)
  end,
})

-- Autoload bash skeleton
vim.api.nvim_command 'autocmd BufNewFile *.sh 0r ~/.config/nvim/skeletons/bash.sh'
