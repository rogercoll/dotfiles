return {
  {
    'fatih/vim-go',
    ft = 'go',
    config = function()
      vim.g.go_fmt_autosave = 1
      vim.g.go_fmt_experimental = 1
      vim.g.go_fmt_command = 'goimports'
    end,
  },
  {
    'rogercoll/rust.vim',
    branch = 'neck_fixes',
    ft = 'rust',
    -- or lazy = false,
    config = function()
      vim.g.rustfmt_autosave = 1
      vim.g.rustfmt_emit_files = 1
    end,
  },
  {
    'rogercoll/open-browser-rustdoc.vim',
    dependencies = {
      'tyru/open-browser.vim',
    },
  },
}
