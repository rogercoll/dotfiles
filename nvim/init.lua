--[[
    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.
    If you experience any errors , run `:checkhealth` for more info.

--]]

-- bootstrap lazy.nvim!
require('neck.bootstrap').lazy()

-- custom nvim options
require 'neck.remap'

-- custom nvim options
require 'neck.options'

-- custom nvim keymaps
require 'neck.keymap'

-- custom nvim autocmd
require 'neck.autocmd'


-- [[ Configure and install plugins ]]
require('lazy').setup({
  { import = 'custom.plugins' },
}, {
  concurrency = 4,
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
