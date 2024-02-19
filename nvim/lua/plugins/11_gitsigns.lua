local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    return
end

gitsigns.setup({
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_formatter = "<abbrev_sha> <author_time:%Y-%m-%d> <summary>",
    current_line_blame_opts = {
        delay = 500,
    },
    word_diff = true,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        -- ([c and ]c to jump between hunks)
        map("n", "]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true })

        -- Actions
        map("n", "<C-g>s", gs.stage_hunk, { desc = "git: Stage hunk" })
        map("n", "<C-g>r", gs.reset_hunk, { desc = "git: Reset hunk" })
        map("v", "<C-g>s", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git: Stage hunk" })
        map("v", "<C-g>r", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git: Reset hunk" })
        map("n", "<C-g>S", gs.stage_buffer, { desc = "git: Stage buffer" })
        map("n", "<C-g>u", gs.undo_stage_hunk, { desc = "git: Undo staging hunk" })
        map("n", "<C-g>R", gs.reset_buffer, { desc = "git: Reset buffer" })
        map("n", "<C-g>p", gs.preview_hunk, { desc = "git: Preview hunk" })
        map("n", "<C-g>b", function()
            gs.blame_line({ full = true })
        end, { desc = "git: Blame line" })
        map("n", "<C-g>tb", gs.toggle_current_line_blame, { desc = "git: Toogle current line blame" })
        map("n", "<C-g>d", gs.diffthis, { desc = "git: Diff this (index)" })
        map("n", "<C-g>D", function()
            gs.diffthis("~")
        end, { desc = "git: Diff this (last commit)" })
        map("n", "<C-g>td", gs.toggle_deleted, { desc = "git: Toggle deleted" })

        -- Text object
        map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>")
    end,
})
