return {
  src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  version = "main",
  name = "nvim-treesitter-textobjects",
  opts = {
    select = {
      lookahead = true,
      include_surrounding_whitespace = false,
    }
  },
  keys = {
    {
      "af",
      function()
        require("nvim-treesitter-textobjects.select")
            .select_textobject("@function.outer", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select outer function",
    },
    {
      "if",
      function()
        require("nvim-treesitter-textobjects.select")
            .select_textobject("@function.inner", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select inner function",
    },
    {
      "ac",
      function()
        require("nvim-treesitter-textobjects.select")
            .select_textobject("@class.outer", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select outer class",
    },
    {
      "ic",
      function()
        require("nvim-treesitter-textobjects.select")
            .select_textobject("@class.inner", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select inner class",
    },
    {
      "as",
      function()
        require("nvim-treesitter-textobjects.select")
            .select_textobject("@local.scope", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select local scope",
    },
    {
      "am",
      function()
        require("nvim-treesitter-textobjects.select")
            .select_textobject("@math.outer", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select outer math",
    },
    {
      "im",
      function()
        require("nvim-treesitter-textobjects.select")
            .select_textobject("@math.inner", "textobjects")
      end,
      mode = { "x", "o" },
      desc = "Select inner math",
    }
  },
  config = true,
}
