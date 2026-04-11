local TS = "nvim-treesitter"

return {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    name = TS,
    enable = true,
    version = "main",
    opts = {
      parsers = { "typst", "python" },
    },
    config = function(opts)
      require(TS).install(opts.parsers)
    end
}
