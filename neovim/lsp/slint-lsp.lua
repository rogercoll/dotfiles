---@brief
---
--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/slint_lsp.lua
--- https://github.com/slint-ui/slint
---
--- Slint language server.

---@type vim.lsp.Config
return {
    cmd = { "slint-lsp" },
    filetypes = { "slint" },
    root_markers = { ".git" },
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            buffer = bufnr,
            callback = function()
                vim.cmd [[silent! !slint-lsp format % --inline]]
            end,
        })
    end,
}
