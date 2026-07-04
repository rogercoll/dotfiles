local keys = {
  { "<leader>f", "GotoFile<cr>", silent = true, desc = "Goto file" },
}

local opts = {
  message_on_error = false,
}

return {
  "ve5li/better-goto-file.nvim",
  config = true,
  keys = keys,
  lazy = false,
  opts = opts,
}
