local ok
local extra, surround, cursorword, indentscope, statusline, pick

ok, extra = pcall(require, "mini.extra")
if ok then
	extra.setup {}
end

ok, surround = pcall(require, "mini.surround")
if ok then
	surround.setup {}
end

ok, cursorword = pcall(require, "mini.cursorword")
if ok then
	cursorword.setup {}
end

ok, indentscope = pcall(require, "mini.indentscope")
if ok then
	indentscope.setup {}
end

ok, statusline = pcall(require, "mini.statusline")
if ok then
	statusline.setup {}
end

ok, pick = pcall(require, "mini.pick")
if ok then
	pick.setup {}
    vim.ui.select = pick.ui_select
end
