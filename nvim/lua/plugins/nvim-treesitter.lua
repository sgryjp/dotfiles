local ok, _ = pcall(require, "nvim-treesitter")
if not ok then
  return
end
local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "lua", "json", "python", "rust" },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
        ["if"] = { query = "@function.inner", desc = "Select outer part of a function" },
        ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = { query = "@function.outer", desc = "Next function" },
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
  highlight = {
    enabled = true,
  },
})

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
