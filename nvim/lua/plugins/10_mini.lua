local ok
local clue, extra, surround, cursorword, indentscope, statusline, pick

ok, clue = pcall(require, "mini.clue")
if ok then
    clue.setup({
        triggers = {
            -- Leader triggers
            { mode = 'n', keys = '<Leader>' },
            { mode = 'x', keys = '<Leader>' },
            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },
            -- `g` key
            { mode = 'n', keys = 'g' },
            { mode = 'x', keys = 'g' },
            -- Marks
            { mode = 'n', keys = "'" },
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = "'" },
            { mode = 'x', keys = '`' },
            -- Registers
            { mode = 'n', keys = '"' },
            { mode = 'x', keys = '"' },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },
            -- Window commands
            { mode = 'n', keys = '<C-w>' },
            -- `z` key
            { mode = 'n', keys = 'z' },
            { mode = 'x', keys = 'z' },
        },

        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
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
