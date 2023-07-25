local ok, kanagawa = pcall(require, "kanagawa")
if not ok then
	return
end

kanagawa.setup {
	compile = true,
	undercurl = false,
}

kanagawa.load("wave")
