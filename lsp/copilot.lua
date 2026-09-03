---@type vim.lsp.Config
return {
  cmd = require("utils.copilot").cmd(),

  -- `filetypes = nil` attacherait le serveur à TOUS les buffers, y compris les
  -- listings de répertoire, l'aide et checkhealth. Liste explicite : seulement
  -- ce dans quoi on écrit vraiment.
  filetypes = {
    "typst", "tex", "plaintex", "bib",
    "lua", "python", "lean",
    "json", "jsonc", "toml", "yaml",
    "sh", "bash", "markdown",
  },

  root_markers = { ".git" },

  init_options = {
    editorInfo = { name = "Neovim", version = tostring(vim.version()) },
    editorPluginInfo = { name = "Neovim", version = tostring(vim.version()) },
  },
}
