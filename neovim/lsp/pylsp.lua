---@brief
---
--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/pylsp.lua
--- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
---
--- Python language server.

---@type vim.lsp.Config
return {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
    },
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            buffer = bufnr,
            callback = function()
                vim.cmd [[silent! !black %]]
            end,
        })
    end,
}
