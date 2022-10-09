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
}
