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
        ["]c"] = { query = "@class.outer", desc = "Next class" },
        ["]]"] = { query = { "@function.outer", "@class.outer" }, desc = "Next class or function" },
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@class.outer",
      },
      goto_previous_start = {
        ["]f"] = { query = "@function.outer", desc = "Previous function" },
        ["]c"] = { query = "@class.outer", desc = "Previous class" },
        ["]]"] = { query = { "@function.outer", "@class.outer" }, desc = "Previous class or function" },
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@class.outer",
      },
    },
  },
  highlight = {
    enabled = true,
  },
})
