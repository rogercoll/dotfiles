vim.g.mapleader = " "

-- Explorer key mapping in normal mode (n)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Preserve last copy after replace
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Dynamic visual move
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
