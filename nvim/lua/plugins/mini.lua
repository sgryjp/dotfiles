local ok
local mini_surround, mini_cursorword

ok, mini_surround = pcall(require, "mini.surround")
if ok then
	mini_surround.setup {}
end

ok, mini_cursorword = pcall(require, "mini.cursorword")
if ok then
	mini_cursorword.setup {}
end
