-- Install mini.nvim and then setup mini.deps
local function install_mini_deps()
  local path_package = vim.fn.stdpath("data") .. "/site/"
  local mini_path = path_package .. "pack/deps/start/mini.nvim"
  if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/echasnovski/mini.nvim",
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
---@type { source: string, _require: string?, _setup: string? }[]
local specs = {
  { source = "echasnovski/mini.nvim", _require = "mini" },
  { source = "kyazdani42/nvim-web-devicons" },
  { source = "nvim-lua/plenary.nvim" },
  { source = "neovim/nvim-lspconfig", _require = "lsp" },
  { source = "nvim-treesitter/nvim-treesitter" },
  { source = "nvim-treesitter/nvim-treesitter-textobjects" },
  { source = "williamboman/mason.nvim", _setup = "mason" },
  { source = "williamboman/mason-lspconfig.nvim" },
  { source = "catppuccin/nvim", name = "catpuccin" },
  { source = "folke/snacks.nvim", _require = "snacks" },

  { source = "stevearc/quicker.nvim", _setup = "quicker" },
  { source = "tpope/vim-fugitive" },
  { source = "elkasztano/nushell-syntax-vim" },
  { source = "nvim-telescope/telescope.nvim", _require = "telescope" },
  { source = "nvim-telescope/telescope-ui-select.nvim" },
  { source = "stevearc/aerial.nvim", _require = "aerial" },
  { source = "stevearc/oil.nvim", _setup = "oil" },
  { source = "stevearc/conform.nvim", _require = "conform" },
  { source = "saghen/blink.cmp", checkout = "v0.14.0", _setup = "blink.cmp" },
  { source = "akinsho/toggleterm.nvim", _require = "toggleterm" },
}

-- Load plugins in declared order
local add, later = MiniDeps.add, MiniDeps.later
for _, spec in ipairs(specs) do
  -- Add the plugin
  add(spec)

  -- Configure the plugin
  if spec._setup then
    later(function() require(spec._setup).setup({}) end)
  elseif spec._require then
    later(function() require("plugins/" .. spec._require) end)
  end
end

-- Load keymaps and vim options
require("keymaps")
require("options")

-- Set colorscheme
vim.cmd("colorscheme catppuccin")
