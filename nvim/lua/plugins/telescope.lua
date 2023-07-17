local trouble = require("trouble.providers.telescope")

local ok, telescope = pcall(require, "telescope")
if not ok then
    return
end

telescope.setup {
    defaults = {
        mappings = {
            i = {
                -- Close Telescope window by Esc even in insert mode
                ["<Esc>"] = "close",
                ["<C-[>"] = "close",

                -- Open result in trouble.nvim
                ["<c-t>"] = trouble.open_with_trouble
            },
            n = {
                -- Open result in trouble.nvim
                ["<c-t>"] = trouble.open_with_trouble
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }
        }
    }
}

require("telescope").load_extension("ui-select")
