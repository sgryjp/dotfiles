local ok, conform = pcall(require, "conform")
if not ok then
    return
end

conform.setup({
    -- Conform will run multiple formatters sequentially.
    -- Use a sub-list to run only the first available formatter.
    formatters_by_ft = {
        html = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        lua = { "stylua" },
        markdown = { { "prettierd", "prettier" } },
        python = { "ruff_format" },
        sh = { "shfmt" },
        swift = { "swift_format" },
        yaml = { { "prettierd", "prettier" } },
    },
    log_level = vim.log.levels.INFO,
})
