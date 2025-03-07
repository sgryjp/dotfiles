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

-- Declare plugins to use
local add, later = MiniDeps.add, MiniDeps.later
local specs = {
  { source = "echasnovski/mini.nvim" },
  { source = "kyazdani42/nvim-web-devicons" },
  { source = "nvim-lua/plenary.nvim" },
  { source = "neovim/nvim-lspconfig" },
  { source = "nvim-treesitter/nvim-treesitter" },
  { source = "nvim-treesitter/nvim-treesitter-textobjects" },
  { source = "williamboman/mason.nvim" },
  { source = "williamboman/mason-lspconfig.nvim" },
  { source = "catppuccin/nvim", name = "catpuccin" },
  { source = "folke/snacks.nvim" },

  { source = "stevearc/quicker.nvim", _setup = { "quicker", {} } },
  { source = "tpope/vim-fugitive" },
  { source = "elkasztano/nushell-syntax-vim" },
  { source = "nvim-telescope/telescope.nvim" },
  { source = "nvim-telescope/telescope-ui-select.nvim" },
  { source = "stevearc/oil.nvim", _setup = { "oil", {} } },
  { source = "stevearc/conform.nvim" },
  { source = "saghen/blink.cmp", name = "blink_cmp", checkout = "v0.13.0", _setup = { "blink.cmp", {} } },
  { source = "simrat39/symbols-outline.nvim" },
  { source = "akinsho/toggleterm.nvim" },
}

-- Load plugins in declared order
for _, spec in ipairs(specs) do
  add(spec)

  local name
  if spec.name then
    name = spec.name
  else
    name = spec.source
    name = string.gsub(name, ".+/(.+)", "%1")
    name = string.gsub(name, "(.+)%.nvim$", "%1")
  end
  local config_path = vim.fn.stdpath("config") .. "/lua/plugins/" .. name .. ".lua"
  if vim.fn.filereadable(config_path) == 1 then
    later(function() require("plugins/" .. name) end)
  elseif spec._setup then
    local n, o = spec._setup[1], spec._setup[2]
    later(function() require(n).setup(o) end)
  end
end

-- Load keymaps and vim options
require("keymaps")
require("options")

-- Set colorscheme
vim.cmd("colorscheme catppuccin")
