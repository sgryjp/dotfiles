-- Setup plugins
local ok1, mason = pcall(require, "mason")
local ok2, mason_lspconfig = pcall(require, "mason-lspconfig")
if not (ok1 and ok2) then
  return
end

-- Set default configuration for LSP clients
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = "LuaJIT",
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
    },
  },
})
vim.lsp.config("typos_ls", {
  cmd_env = { RUST_LOG = "info" },
  init_options = {
    diagnosticSeverity = "hint",
  },
})

-- Enable LSP servers
mason.setup({})
mason_lspconfig.setup({})
vim.lsp.enable("nushell")

-- Setup LSP servers independently from Mason
vim.lsp.config("nushell", {})
