---@type vim.lsp.Config
return {
  cmd = { 'tinymist' },

  filetypes = { 'typst' },

  -- La racine décide de ce que `/` désigne dans un import absolu, donc le projet
  -- typst prime sur le dépôt git qui le contient : les marqueurs sont donnés par
  -- priorité décroissante. Sans marqueur, tinymist prend le dossier du fichier
  -- ouvert — un chapitre verrait alors sa propre racine.
  root_markers = { { 'main.typ', 'typst.toml' }, '.git' },

  settings = {
    -- singleFile, et non lockDatabase : ce dernier ne relie un chapitre à son
    -- document qu'après un export, via une table de routes stockée dans le cache
    -- utilisateur, et un export lancé depuis un chapitre l'écrase. C'est
    -- lua/typst/actions.lua qui épingle le principal, par convention.
    projectResolution = 'singleFile',
    exportPdf = 'never',
    formatterMode = 'typstyle',
    lint = { enabled = true },
    completion = { triggerOnSnippetPlaceholders = true, },
  },

}
