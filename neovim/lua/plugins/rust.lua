local function config()
    vim.g.rustfmt_autosave = 1
    vim.g.rustfmt_emit_files = 1
end

return {
    "rust-lang/rust.vim",
    ft = "rust",
    config = config,
}
