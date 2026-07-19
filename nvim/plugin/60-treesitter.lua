-- Parsers pre-compiled by Nix (programs.neovim.plugins nvim-treesitter.withPlugins).
-- Neovim's built-in treesitter handles highlighting — no plugin setup needed.
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
