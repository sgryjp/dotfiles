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
