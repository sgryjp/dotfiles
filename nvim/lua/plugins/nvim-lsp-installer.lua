local ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not ok then
    return
end

lsp_installer.on_server_ready(function(server)
    local config = {}

    if server.name == "sumneko_lua" then
        config.settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
            },
        }
    end

    server:setup(config)
    vim.cmd("do User LspAttachBuffers")
end)
