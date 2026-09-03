---@type vim.lsp.Config
return {
  cmd = { 'tinymist' },

  filetypes = { 'typst' },

  root_markers = { 'tinymist.lock', '.git' },

  settings = {
    projectResolution = "lockDatabase",
    exportPdf = 'never',
    outputPath = "$root/$dir/$name",
    formatterMode = 'typstyle',
    lint = { enabled = true },
    completion = { triggerOnSnippetPlaceholders = true, },
  },

}
