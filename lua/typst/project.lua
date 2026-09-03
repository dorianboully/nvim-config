-- Résolution du document principal d'un projet typst.
--
-- Rien ne distingue main.typ d'un chapitre inclus : même extension, même
-- syntaxe. tinymist offre `projectResolution = "lockDatabase"` pour retrouver
-- l'entrée en rejouant l'historique de compilation, mais sa table de routes
-- n'existe qu'après un export réussi et vit dans un cache hors du projet ; tant
-- qu'elle est vide, chaque fichier redevient son propre document — et un export
-- lancé depuis un chapitre y inscrit le chapitre, ce qui écrase la route du
-- projet. On s'en passe : le principal est déduit par convention, tout de suite
-- et sans état sur le disque.

local M = {}

--- Entrypoint déclaré par le typst.toml d'un paquet, s'il en déclare un.
---@param dir string
---@return string?
local function entrypoint(dir)
  local manifest = vim.fs.joinpath(dir, "typst.toml")
  if vim.fn.filereadable(manifest) ~= 1 then
    return nil
  end

  for _, line in ipairs(vim.fn.readfile(manifest)) do
    local entry = line:match('^%s*entrypoint%s*=%s*"([^"]+)"')
    if entry then
      return vim.fs.joinpath(dir, entry)
    end
  end
  return nil
end

--- Racine du projet contenant `path` : le plus proche ancêtre portant un
--- main.typ ou un typst.toml, à défaut le dossier du fichier.
---@param path string
---@return string
function M.root(path)
  return vim.fs.root(path, { "main.typ", "typst.toml" }) or vim.fs.dirname(path)
end

--- Principaux imposés par l'utilisateur, indexés par racine pour que deux
--- projets ouverts dans la même session ne se mélangent pas.
---@type table<string, string>
local forced = {}

--- Document principal dont `path` fait partie. À défaut de convention
--- reconnaissable, `path` lui-même : un fichier seul est son propre document.
---@param path string
---@return string
function M.main(path)
  if path == "" then
    return path
  end

  local root = M.root(path)
  if forced[root] then
    return forced[root]
  end

  local main = vim.fs.joinpath(root, "main.typ")
  if vim.fn.filereadable(main) == 1 then
    return main
  end

  local entry = entrypoint(root)
  return (entry and vim.fn.filereadable(entry) == 1) and entry or path
end

--- Impose `path` comme principal de son projet.
---@param path string
function M.force(path)
  forced[M.root(path)] = path
end

--- Rend le projet de `path` à la détection par convention.
---@param path string
---@return string principal redevenu effectif
function M.release(path)
  forced[M.root(path)] = nil
  return M.main(path)
end

return M
