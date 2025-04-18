-- Setup plugins
local ok1, lspconfig = pcall(require, "lspconfig")
local ok2, mason = pcall(require, "mason")
local ok3, mason_lspconfig = pcall(require, "mason-lspconfig")
if not (ok1 and ok2 and ok3) then
  return
end

-- Make omnifunc LSP based completion
vim.omnifunc = "v:lua.vim.lsp.omnifunc"

mason.setup({})
-- mason_lspconfig.setup {
--     automatic_installation = true
-- }

local function configure_server(server_name)
  local opts = {}
  if server_name == "lua_ls" then
    opts = {
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
    }
  elseif server_name == "typos_ls" then
    opts = {
      cmd_env = { RUST_LOG = "info" },
      init_options = {
        diagnosticSeverity = "hint",
      },
    }
  end
  lspconfig[server_name].setup(opts)
end

-- Define list of servers which I prefer to use
local configured_servers = {
  nushell = false,
  -- pyright = false,
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
