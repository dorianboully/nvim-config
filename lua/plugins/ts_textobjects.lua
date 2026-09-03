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
  -- `as` (portée) est retiré : v_an / v_in couvrent l'expansion par nœud
  -- depuis 0.12. `am` / `im` (math) sont passés dans after/ftplugin/typst.lua :
  -- la requête n'existe que pour typst, et en TeX c'est vimtex qui les fournit.
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
  },
  config = true,
}
