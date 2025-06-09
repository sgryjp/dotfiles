local ok, conform = pcall(require, "conform")
if not ok then
  return
end

conform.setup({
  -- Conform will run multiple formatters sequentially.
  -- Use a sub-list to run only the first available formatter.
  formatters_by_ft = {
    html = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    lua = { "stylua" },
    markdown = { "prettierd", "prettier", stop_after_first = true },
    python = { "ruff_format" },
    rust = { "trim_whitespace", "rustfmt", lsp_format = "fallback" },
    sh = { "shfmt" },
    swift = { "swift_format" },
    toml = { "taplo" },
    yaml = { "prettierd", "prettier", stop_after_first = true },
  },
  log_level = vim.log.levels.INFO,
})
