local builtin = require('telescope.builtin')

-- find project files (pv) in normal mode
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- find current git files with ctrl + p
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- project search
vim.keymap.set('n', '<leader>ps',   function()
	builtin.grep_string({search = vim.fn.input("Grep > ")});
end)
