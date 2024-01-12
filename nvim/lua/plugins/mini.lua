local ok
local mini_surround, mini_cursorword, indentscope

ok, mini_surround = pcall(require, "mini.surround")
if ok then
	mini_surround.setup {}
end

ok, mini_cursorword = pcall(require, "mini.cursorword")
if ok then
	mini_cursorword.setup {}
end

ok, indentscope = pcall(require, "mini.indentscope")
if ok then
	indentscope.setup {}
end

ok, statusline = pcall(require, "mini.statusline")
if ok then
	statusline.setup {}
end
