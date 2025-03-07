local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

require("telescope").load_extension("ui-select")

telescope.setup({
  defaults = {
    layout_config = {
      height = vim.o.lines,
      width = vim.o.columns,
      prompt_position = "top",
    },
    layout_strategy = "bottom_pane",
    sorting_strategy = "ascending",
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})
