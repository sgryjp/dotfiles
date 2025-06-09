-- Setup plugins
local ok1, lspconfig = pcall(require, "lspconfig")
local ok2, mason = pcall(require, "mason")
local ok3, mason_lspconfig = pcall(require, "mason-lspconfig")
if not (ok1 and ok2 and ok3) then
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
lspconfig["nushell"].setup({})
lspconfig["ruff"].setup({})
