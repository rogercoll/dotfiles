return {
  {
    "Saecki/crates.nvim",
    depedencies = {'nvim-lua/plenary.nvim'},
    config = function()
      require("crates").setup()
    end,
  },
  "rust-lang/rust.vim",
}

