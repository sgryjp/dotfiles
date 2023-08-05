local ok
local mini_surround

ok, mini_surround = pcall(require, "mini.surround")
if ok then
	mini_surround.setup {}
end
