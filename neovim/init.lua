vim.g.mapleader = " "

local with_mason = vim.loop.fs_stat "/etc/nixos" == nil
local base46_cache_dir = with_mason and "/nvchad/base46/" or "/base46/"
vim.g.base46_cache = vim.fn.stdpath "data" .. base46_cache_dir

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require("lazy").setup({
    {
        "NvChad/NvChad",
        lazy = false,
        branch = "v2.5",
        import = "nvchad.plugins",
        config = function()
            require "nvchad.autocmds"
        end,
    },
    {
        import = "plugins",
    },
}, lazy_config)

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "lsp"

vim.schedule(function()
    require "mappings"
end)
