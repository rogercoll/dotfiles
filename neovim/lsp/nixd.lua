---@brief
---
--- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/nixd.lua
--- https://github.com/nix-community/nixd
---
--- Nix language server, based on nix libraries.
---
--- If you are using Nix with Flakes support, run `nix profile install github:nix-community/nixd` to install.
--- Check the repository README for more information.

---@type vim.lsp.Config
return {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
        nixd = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            buffer = bufnr,
            callback = function()
                vim.cmd [[silent! !nixfmt %]]
            end,
        })
    end,
}
