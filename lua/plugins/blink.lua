return {
  src = "https://github.com/saghen/blink.cmp",

  name = "blink.cmp",

  opts = {
    completion = {
      menu = {
        auto_show = function() return vim.bo.filetype ~= "typst" end
      }
    },
    snippets = {
      preset = "luasnip",
    },
  },

  config = true
}
