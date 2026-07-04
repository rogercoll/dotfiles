-- find lsp configurations here:
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
--
-- TODO: on Nvim v0.12
-- vim.pack.add {
--     { src = "https://github.com/neovim/nvim-lspconfig" },
-- }

vim.lsp.enable {
    "lua_ls",
    "nixd",
    "pylsp",
    "rust_analyzer",
    "slint-lsp",
    "tombi",
}
