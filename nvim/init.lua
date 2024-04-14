-- Share configuration of VIM
vim.cmd("set runtimepath^=~/.vim runtimepath+=~/.vim/after")
vim.cmd("let &packpath=&runtimepath")
vim.cmd("runtime vimrc")

-- Load plugins config files in filename order.
local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local plugins = vim.fn.readdir(plugin_dir)
table.sort(plugins)

for _, plugin in ipairs(plugins) do
    if plugin:match("%.lua$") then
        if not vim.g.vscode or plugin:match("%mini.lua$") then
            require("plugins/" .. plugin:gsub("%.lua$", ""))
        end
    end
end

-- Load neovim only keymaps
require("keymaps")
