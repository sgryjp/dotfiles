local ok, telescope = pcall(require, "telescope")
if not ok then
    return
end

telescope.setup {
    -- This default is based on `require('telescope.themes').get_ivy()`
    defaults = {
        border = true,
        borderchars = {
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
            results = { " " }
        },
        layout_config = {
            height = 25
        },
        layout_strategy = "bottom_pane",
        sorting_strategy = "ascending",
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        },
    }
}

require("telescope").load_extension("ui-select")
