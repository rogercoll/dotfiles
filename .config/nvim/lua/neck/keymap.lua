-- [[ Basic Keymaps ]]
--  Basic buffers keymaps
vim.keymap.set('n', '<leader>h', ':bp<CR>', { desc = '[P]revious buffer' })
vim.keymap.set('n', '<leader>l', ':bn<CR>', { desc = '[N]ext buffer' })
--  See `:help vim.keymap.set()`
vim.keymap.set('n', '<leader>x', vim.cmd.Ex, { desc = 'Open file e[X]plorer' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines up' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines down' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Keep cursor in the middle while <C-d>' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Keep cursor in the middle while <C-u>' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Keep cursor while searching' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Keep cursor while backwards searching' })

-- greatest remap ever
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without losing previous content' })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>pd', vim.diagnostic.goto_prev, { desc = 'Go to [P]revious [D]iagnostic message' })
vim.keymap.set('n', '<leader>nd', vim.diagnostic.goto_next, { desc = 'Go to [N]ext [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
