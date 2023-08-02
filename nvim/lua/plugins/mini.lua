local ok, mini_files = pcall(require, "mini.files")
print(mini_files)
if not ok then
	return
end

mini_files.setup {}
