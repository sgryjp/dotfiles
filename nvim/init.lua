-- Install mini.nvim and then setup mini.deps
local function install_mini_deps()
  local path_package = vim.fn.stdpath("data") .. "/site"
  local mini_path = path_package .. "/pack/deps/start/mini.nvim"
  if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
      "git",
      "clone",
      "--filter=blob:none",
      -- Uncomment next line to use 'stable' branch
      "--branch",
      "stable",
      "https://github.com/nvim-mini/mini.nvim",
      mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
  end

  local deps = require("mini.deps")
  deps.setup({ path = { package = path_package } })
  return deps
end
local MiniDeps = install_mini_deps()

-- Declare plugins
---@type { source: string, _require: string?, _opts: table? }[]
local specs = {
  { source = "echasnovski/mini.nvim", _require = "mini" },
  { source = "kyazdani42/nvim-web-devicons" },
  { source = "nvim-lua/plenary.nvim" },
  { source = "neovim/nvim-lspconfig", _require = "lsp" },
  { source = "seblyng/roslyn.nvim", _require = "roslyn" },
  { source = "nvim-treesitter/nvim-treesitter", _require = "nvim-treesitter" },
  { source = "nvim-treesitter/nvim-treesitter-textobjects" },
  { source = "mason-org/mason.nvim", _require = "mason" },
  { source = "mason-org/mason-lspconfig.nvim" },
  { source = "catppuccin/nvim", name = "catpuccin" },
  { source = "folke/snacks.nvim", _require = "snacks" },

  { source = "stevearc/quicker.nvim", _opts = {} },
  { source = "tpope/vim-fugitive" },
  { source = "elkasztano/nushell-syntax-vim" },
  { source = "stevearc/aerial.nvim", _require = "aerial" },
  { source = "stevearc/oil.nvim", _opts = {} },
  { source = "stevearc/conform.nvim", _require = "conform" },
  { source = "saghen/blink.cmp", checkout = "v1.8.0", _opts = { signature = { enabled = true } } },
  { source = "akinsho/toggleterm.nvim", _require = "toggleterm" },
  { source = "hat0uma/csvview.nvim", _opts = {} },
}

-- Load plugins in declared order
local add, later = MiniDeps.add, MiniDeps.later
for _, spec in ipairs(specs) do
  -- Add the plugin
  add(spec)

  -- Configure the plugin
  if spec._opts then
    local main = spec.source
    main = string.gsub(main, ".*/", "", 1)
    main = string.gsub(main, "%.nvim$", "", 1)
    later(function() require(main).setup(spec._opts) end)
  elseif spec._require then
    later(function() require("plugins/" .. spec._require) end)
  end
end

-- Load keymaps and vim options
require("keymaps")
require("options")

-- Set colorscheme
vim.cmd("colorscheme catppuccin")
