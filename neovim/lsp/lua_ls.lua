---@brief
---
--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
--- https://github.com/luals/lua-language-server
---
--- Lua language server.

---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".emmyrc.json",
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
    settings = {
        Lua = {
            codeLens = { enable = true },
            hint = { enable = true, semicolon = "Disable" },
        },
    },
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            buffer = bufnr,
            callback = function()
                vim.cmd [[silent! !stylua %]]
            end,
        })
    end,
}
