-- Install mini.nvim and then setup mini.deps
function install_mini_deps()
    local path_package = vim.fn.stdpath('data') .. '/site/'
    local mini_path = path_package .. 'pack/deps/start/mini.nvim'
    if not vim.loop.fs_stat(mini_path) then
        vim.cmd('echo "Installing `mini.nvim`" | redraw')
        local clone_cmd = {
            'git', 'clone', '--filter=blob:none',
            'https://github.com/echasnovski/mini.nvim', mini_path
        }
        vim.fn.system(clone_cmd)
        vim.cmd('packadd mini.nvim | helptags ALL')
        vim.cmd('echo "Installed `mini.nvim`" | redraw')
    end
    local deps = require('mini.deps')
    deps.setup({ path = { package = path_package } })
end
install_mini_deps()

-- Add plugins
local add = require("mini.deps").add
add({ source = 'kyazdani42/nvim-web-devicons' })
add({ source = 'nvim-lua/plenary.nvim' })
add({ source = 'neovim/nvim-lspconfig' })
add({ source = 'nvim-treesitter/nvim-treesitter' })
add({ source = 'nvim-treesitter/nvim-treesitter-textobjects' })
add({ source = 'williamboman/mason.nvim' })
add({ source = 'williamboman/mason-lspconfig.nvim' })
add({ source = 'catppuccin/nvim', name = 'catpuccin' })

add({ source = 'tpope/vim-fugitive' })
add({ source = 'elkasztano/nushell-syntax-vim' })
add({ source = 'nvim-telescope/telescope.nvim' })
add({ source = 'nvim-telescope/telescope-ui-select.nvim' })
add({ source = 'stevearc/oil.nvim' })
add({ source = 'echasnovski/mini.nvim' })
add({ source = 'ray-x/lsp_signature.nvim' })
add({ source = 'hrsh7th/nvim-cmp' })
add({ source = 'hrsh7th/cmp-nvim-lsp' })
add({ source = 'hrsh7th/cmp-nvim-lua' })
add({ source = 'hrsh7th/cmp-buffer' })
add({ source = 'hrsh7th/cmp-cmdline' })
add({ source = 'hrsh7th/cmp-vsnip' })
add({ source = 'hrsh7th/vim-vsnip' })
add({ source = 'onsails/lspkind-nvim' })
add({ source = 'stevearc/conform.nvim' })
add({ source = 'lewis6991/gitsigns.nvim' })
add({ source = 'simrat39/symbols-outline.nvim' })
add({ source = 'akinsho/toggleterm.nvim' })

-- Configure plugins
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

-- Load keymaps and vim options
require("keymaps")
require("options")

-- Set colorscheme
vim.cmd("colorscheme catppuccin")
