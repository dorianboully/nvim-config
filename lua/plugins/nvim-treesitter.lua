local name = "nvim-treesitter"

return {
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  name = name,
  enable = true,
  version = "main",
  opts = {
    parsers = { "typst" },
  },
  config = function(opts)
    require(name).install(opts.parsers)
  end
}
