-- Set border to floating windows for Neovim's built-in LSP handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    title = " Hover ",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    title = " Signature Help ",
})

-- Setup plugins
local ok1, lspconfig = pcall(require, "lspconfig")
local ok2, mason = pcall(require, "mason")
local ok3, mason_lspconfig = pcall(require, "mason-lspconfig")
if not (ok1 and ok2 and ok3) then
    return
end

-- Make omnifunc LSP based completion
vim.omnifunc = 'v:lua.vim.lsp.omnifunc'

mason.setup({})
-- mason_lspconfig.setup {
--     automatic_installation = true
-- }

local function configure_server(server_name)
    local opts = {}
    if server_name == "lua_ls" then
        local libpath = {}
        table.insert(libpath, vim.fn.stdpath("config") .. "/lua")
        table.insert(libpath, vim.env.VIMRUNTIME .. "/lua")
        opts = {
            settings = {
                Lua = {
                    runtime = "LuaJIT",
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = libpath,
                    },
                },
            },
        }
    end
    lspconfig[server_name].setup(opts)
end

-- Define list of servers which I prefer to use
local configured_servers = {
    nushell = false,
    pyright = false,
}

-- Setup servers managed by mason.nvim and then manually setup the rest
mason_lspconfig.setup_handlers({
    function(server_name)
        configure_server(server_name)
        configured_servers[server_name] = true
    end,
})
for server_name, installed in pairs(configured_servers) do
    if not installed then
        configure_server(server_name)
    end
end
