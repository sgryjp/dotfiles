local ok, conform = pcall(require, "conform")
if not ok then
  return
end

conform.setup({
  -- Conform will run multiple formatters sequentially.
  -- Use a sub-list to run only the first available formatter.
  formatters_by_ft = {
    cs = { "csharpier" },
    css = { "oxfmt" },
    html = { "oxfmt", "prettier" },
    javascriptreact = { "oxfmt", "oxlint" },
    json = { "oxfmt", "prettier" },
    less = { "oxfmt" },
    lua = { "stylua" },
    markdown = { "oxfmt", "prettier" },
    nu = { "nufmt" },
    python = { "ruff_format" },
    rust = { "trim_whitespace", "rustfmt", lsp_format = "fallback" },
    sh = { "shfmt" },
    sql = { "sleek" },
    swift = { "swift_format" },
    toml = { "oxfmt", "taplo" },
    typescript = { "oxfmt", "oxlint" },
    typescriptreact = { "oxfmt", "oxlint" },
    yaml = { "oxfmt", "oxlint", "prettier" },
  },
  log_level = vim.log.levels.INFO,
})
