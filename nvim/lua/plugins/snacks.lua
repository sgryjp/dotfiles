local ok, snacks = pcall(require, "snacks")
if not ok then
  return
end

snacks.setup({
  bigfile = {},
  explorer = {},
  -- indent = {},
  -- input = {},
  -- notifier = {},
  picker = {},
  -- quickfile = {},
  -- scope = {},
  -- scroll = {},
  -- statuscolumn = {},
  -- terminal = {},
  words = {},
})
