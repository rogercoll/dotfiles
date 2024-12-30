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
      vim.keymap.set('n', '<leader>re', 'oif err != err {<CR>}<ESC>Oreturn err<ESC>', { desc = '[R]eturn [E]rror' })
      -- TODO: Add more keymaps here
    end)
  end,
})

-- Autoload bash skeleton
vim.api.nvim_command 'autocmd BufNewFile *.sh 0r ~/.config/nvim/skeletons/bash.sh'

-- TERMINAL
-- Remove line numbers Neovim term
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})
-- Small term
local job_id = 0
vim.keymap.set('n', '<space>st', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 10)

  job_id = vim.bo.channel
end, { desc = '[S]mall [T]erminal' })

vim.keymap.set('n', '<space>got', function()
  vim.fn.chansend(job_id, { 'go test -cover -v ./..\r\n' })
end)
