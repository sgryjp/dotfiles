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
install_mini_deps()

-- Load plugins
require("plugins")

-- Load keymaps and vim options
require("keymaps")
require("options")

-- Set colorscheme
vim.cmd("colorscheme catppuccin")
