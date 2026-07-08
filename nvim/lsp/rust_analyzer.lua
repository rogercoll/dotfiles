---@type vim.lsp.Config
return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)

        local user_home = vim.fs.normalize(vim.env.HOME)
        local cargo_home = os.getenv "CARGO_HOME" or user_home .. "/.cargo"
        local registry = cargo_home .. "/registry/src"
        local git_registry = cargo_home .. "/git/checkouts"
        local rustup_home = os.getenv "RUSTUP_HOME" or user_home .. "/.rustup"
        local toolchains = rustup_home .. "/toolchains"

        for _, item in ipairs { toolchains, registry, git_registry } do
            if vim.fs.relpath(item, fname) then
                local clients = vim.lsp.get_clients { name = "rust_analyzer" }
                if #clients > 0 then
                    on_dir(clients[#clients].config.root_dir)
                    return
                end
            end
        end

        local cargo_crate_dir = vim.fs.root(fname, { "Cargo.toml" })

        if cargo_crate_dir == nil then
            on_dir(
                vim.fs.root(fname, { "rust-project.json" })
                    or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
            )
            return
        end

        vim.system(
            { "cargo", "metadata", "--no-deps", "--format-version", "1", "--manifest-path", cargo_crate_dir .. "/Cargo.toml" },
            { text = true },
            function(output)
                if output.code == 0 and output.stdout then
                    local result = vim.json.decode(output.stdout)
                    if result["workspace_root"] then
                        on_dir(vim.fs.normalize(result["workspace_root"]))
                        return
                    end
                end
                on_dir(cargo_crate_dir)
            end
        )
    end,
    settings = {
        ["rust-analyzer"] = {
            lens = {
                enable = true,
                debug = { enable = true },
                implementations = { enable = true },
                references = {
                    adt = { enable = true },
                    enumVariant = { enable = true },
                    method = { enable = true },
                    trait = { enable = true },
                },
                run = { enable = true },
            },
        },
    },
    before_init = function(init_params, config)
        if config.settings and config.settings["rust-analyzer"] then
            init_params.initializationOptions = config.settings["rust-analyzer"]
        end
    end,
    on_attach = function(client, _)
        client.server_capabilities.semanticTokensProvider = false
    end,
}
