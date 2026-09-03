---@type vim.lsp.Config
return {
  -- npm i -g --prefix ~/.local @github/copilot-language-server
  cmd = { 'copilot-language-server', '--stdio' },

  -- `filetypes = nil` attacherait le serveur à TOUS les buffers, y compris les
  -- listings de répertoire, l'aide et checkhealth. Liste explicite : seulement
  -- ce dans quoi on écrit vraiment.
  filetypes = {
    'typst', 'tex', 'plaintex', 'bib',
    'lua', 'python', 'lean',
    'json', 'jsonc', 'toml', 'yaml',
    'sh', 'bash', 'markdown',
  },

  root_markers = { '.git' },

  init_options = {
    editorInfo = { name = 'Neovim', version = tostring(vim.version()) },
    editorPluginInfo = { name = 'Neovim', version = tostring(vim.version()) },
  },
}
