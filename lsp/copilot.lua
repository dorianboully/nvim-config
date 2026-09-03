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

  -- Authentification par variable d'environnement, posée dans le shell :
  --   export GITHUB_COPILOT_TOKEN=...   (ou GH_COPILOT_TOKEN)
  -- Le serveur n'a pas de mode connexion en ligne de commande, et son seul
  -- magasin d'identifiants est keytar — qui échoue sous WSL faute de service
  -- de secrets D-Bus. Le flux d'appareil ne persisterait donc rien.
  -- (GITHUB_TOKEN n'est lu que si CODESPACES=true.)

  -- Sans ce gestionnaire, un défaut d'authentification est parfaitement
  -- silencieux : la requête part, le serveur répond NotSignedIn, et aucune
  -- suggestion n'apparaît sans le moindre message.
  handlers = {
    ['didChangeStatus'] = function(_, result)
      if result and result.kind == 'Error' then
        vim.schedule(function()
          vim.notify('copilot : ' .. (result.message or 'erreur'), vim.log.levels.WARN)
        end)
      end
    end,
  },

  init_options = {
    editorInfo = { name = 'Neovim', version = tostring(vim.version()) },
    editorPluginInfo = { name = 'Neovim', version = tostring(vim.version()) },
  },
}
