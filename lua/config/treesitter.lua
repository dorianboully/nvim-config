local Parsers = {
  latex = { "tex", "plaintex" },
  typst = "typst" ,
  lua = "lua",
  json = "json",
  toml = "toml",
  python = "python",
}

vim.iter(pairs(Parsers)):each(function(parser, filetypes)
  vim.treesitter.language.register(parser, filetypes)

  vim.api.nvim_create_autocmd('FileType', {
    pattern = filetypes,
    callback = function(ev)
      vim.treesitter.start(ev.buf, parser)
    end
  })
end)
