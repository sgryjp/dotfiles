local ok
local clue, completion, extra, notify, surround, cursorword, indentscope, statusline, pick

if vim.g.vscode then
    ok, surround = pcall(require, "mini.surround")
    if ok then
        surround.setup({})
    end
else
    ok, completion = pcall(require, "mini.completion")
    if ok then
        completion.setup({})
    end

    ok, clue = pcall(require, "mini.clue")
    if ok then
        clue.setup({
            window = {
                delay = 250,
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
    end

    ok, extra = pcall(require, "mini.extra")
    if ok then
        extra.setup({})
    end

    ok, notify = pcall(require, "mini.notify")
    if ok then
        notify.setup({})
        vim.notify = notify.make_notify()
    end

    ok, cursorword = pcall(require, "mini.cursorword")
    if ok then
        cursorword.setup({})
    end

    ok, indentscope = pcall(require, "mini.indentscope")
    if ok then
        indentscope.setup({})
    end

    ok, statusline = pcall(require, "mini.statusline")
    if ok then
        statusline.setup({})
    end

    ok, pick = pcall(require, "mini.pick")
    if ok then
        pick.setup({})
        vim.ui.select = pick.ui_select
    end
end
