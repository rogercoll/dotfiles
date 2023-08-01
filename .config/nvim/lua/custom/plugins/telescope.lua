return {
  {
    "nvim-telescope/telescope.nvim",
    priority = 100,
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-hop.nvim",
  "nvim-telescope/telescope-ui-select.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
