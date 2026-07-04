return {
    "saecki/crates.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    tag = "stable",
    config = function()
        require("crates").setup()
    end,
    ft = "toml",
}
