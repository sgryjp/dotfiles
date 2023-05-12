local ok1, lspconfig = pcall(require, "lspconfig")
local ok2, mason = pcall(require, "mason")
local ok3, mason_lspconfig = pcall(require, "mason-lspconfig")
if not (ok1 and ok2 and ok3) then
    return
end

mason.setup {}
mason_lspconfig.setup {
    automatic_installation = true
}


mason_lspconfig.setup_handlers({ function(server_name)
    local opts = {}
    lspconfig[server_name].setup(opts)
end });