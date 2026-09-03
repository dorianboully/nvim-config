local M = {}

--- Chemin du serveur embarqué par le dépôt copilot.vim. vim.pack le garde à
--- jour et fixe sa révision dans le lockfile, mais ne le charge jamais comme
--- plugin : voir lua/plugins/copilot.lua.
local function bundled()
  return vim.fs.joinpath(
    vim.fn.stdpath("data"),
    "site", "pack", "core", "opt",
    "copilot", "copilot-language-server", "dist", "language-server.js"
  )
end

---@type string[]|false|nil  false = déjà cherché, introuvable
local cached

--- Commande de lancement du serveur, ou nil s'il est introuvable.
---
--- La copie embarquée passe en premier : c'est la dépendance déclarée, celle
--- dont vim.pack fixe la version. Une installation sur le PATH ne sert que de
--- repli, si le dépôt copilot.vim venait à ne plus livrer le serveur.
---
--- L'ordre compte pour le temps de démarrage : sous WSL2 le PATH contient ici
--- 34 dossiers Windows, et une recherche infructueuse par vim.fn.executable()
--- coûte ~75 ms — sans être mise en cache par Neovim. Le fs_stat coûte 0,14 ms.
---@return string[]?
function M.cmd()
  if cached ~= nil then
    return cached or nil
  end

  local js = bundled()
  if vim.uv.fs_stat(js) and vim.fn.executable("node") == 1 then
    cached = { "node", js, "--stdio" }
  elseif vim.fn.executable("copilot-language-server") == 1 then
    cached = { "copilot-language-server", "--stdio" }
  else
    cached = false
  end

  return cached or nil
end

return M
