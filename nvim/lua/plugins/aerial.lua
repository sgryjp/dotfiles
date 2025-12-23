local ok, aerial = pcall(require, "aerial")
if not ok then
  return
end

aerial.setup({
  keymaps = {
    -- Allow closing by Esc too
    ["<C-[>"] = "actions.close",
  },
})
