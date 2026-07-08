local with_mason = vim.loop.fs_stat "/etc/nixos" == nil

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'go', 'rust', 'terraform', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      auto_install = with_mason,
      highlight = { enable = true },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
}
