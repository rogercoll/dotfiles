local with_mason = vim.loop.fs_stat "/etc/nixos" == nil

return {
    "mason-org/mason.nvim",
    enabled = with_mason,
    opts = {
        ensure_installed = {
            "black",
            "lua-language-server",
            "nixfmt",
            "python-lsp-server",
            "rust-analyzer",
            "slint-lsp",
            "stylua",
            "tombi",
        },
    },
}
