local ok, inlay_hints = pcall(require, "inlay-hints")
if not ok then
    return
end

inlay_hints.setup({})
