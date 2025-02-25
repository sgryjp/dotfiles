local mini_available, clue = pcall(require, "mini.clue")
if not mini_available then
	return
end

require("mini.ai").setup({})
require("mini.diff").setup({})
require("mini.surround").setup({})
if not vim.g.vscode then
	require("mini.completion").setup({})
	require("mini.cursorword").setup({})
	require("mini.extra").setup({})
	require("mini.icons").setup({})
	require("mini.indentscope").setup({})
	require("mini.notify").setup({
		window = { max_width_share = 0.5 },
	})
	require("mini.statusline").setup({})
	require("mini.surround").setup({})
	require("mini.trailspace").setup({})

	clue.setup({
		window = {
			delay = 250,
			config = { anchor = "SE", width = 48, row = "auto", col = "auto" },
		},
		triggers = {
			{ mode = "n", keys = "\\" },
			{ mode = "x", keys = "\\" },
			{ mode = "n", keys = "<Space>" },
			{ mode = "x", keys = "<Space>" },
			{ mode = "i", keys = "<C-x>" },
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },
			{ mode = "n", keys = "<C-w>" },
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
			{ mode = "n", keys = "[" },
			{ mode = "n", keys = "]" },
			-- gitsigns
			{ mode = "n", keys = "<C-g>" },
		},
		clues = {
			clue.gen_clues.builtin_completion(),
			clue.gen_clues.g(),
			clue.gen_clues.marks(),
			clue.gen_clues.registers(),
			clue.gen_clues.windows(),
			clue.gen_clues.z(),
		},
	})

	vim.notify = require("mini.notify").make_notify()
end
