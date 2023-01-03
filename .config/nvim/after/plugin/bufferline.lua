require'bufferline'.setup {
    icons = false,
    closable = false,
    clickable = false,
    auto_hide = true,
}
-- BufferPick
vim.keymap.set("n", "<leader>bp", vim.cmd.BufferPick);
