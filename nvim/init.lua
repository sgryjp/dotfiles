-- Share configuration of VIM
vim.cmd("set runtimepath^=~/.vim runtimepath+=~/.vim/after")
vim.cmd("let &packpath=&runtimepath")
vim.cmd("runtime vimrc")

-- Load plugins config files in filename order.
local function load_plugins()
    local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
    local plugins = vim.fn.readdir(plugin_dir)
    table.sort(plugins)

    for _, plugin in ipairs(plugins) do
        if plugin:match("%.lua$") then
            require("plugins/" .. plugin:gsub("%.lua$", ""))
        end
    end
end

if not vim.g.vscode then
    load_plugins()
end
