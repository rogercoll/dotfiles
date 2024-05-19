return {
  'norcalli/nvim-colorizer.lua',
  {
    'norcalli/nvim-terminal.lua',
    config = function()
      require('terminal').setup()
    end,
  },
  'tjdevries/colorbuddy.nvim',
}
