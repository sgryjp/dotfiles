local ok, lualine = pcall(require, "lualine")
if not ok then
	return
end

lualine.setup {
	options = {
		globalstatus = true, -- nvim 0.7+
	},
	sections = {
		lualine_c = {
			{
				'filetype',
				icon_only = true,
				separator = '',
				padding = { right = 0, left = 1 }
			},
			{
				'filename',
				path = 1,
			},
		},
		lualine_x = { 'encoding', 'fileformat' },
	},
	extensions = { 'fugitive' },
}
