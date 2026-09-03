-- Chargement des plugins.
--
-- Chaque fichier de lua/plugins/ renvoie une spec vim.pack (`src`, `name`,
-- `version`) enrichie de trois champs à nous :
--   opts    table passée à setup()
--   config  true -> require(name).setup(opts), ou une fonction reçevant opts
--   keys    table de raccourcis, appliquée après config
--
-- Tout le reste est natif : :packupdate met à jour, :packdel ++all retire les
-- plugins inactifs, et le lockfile fixe les révisions.

local M = {}

---@param spec table
local function apply(spec)
  if spec.config == true then
    require(spec.name).setup(spec.opts)
  elseif type(spec.config) == "function" then
    spec.config(spec.opts)
  end
  require("utils.keymap").mapKeys(spec.keys)
end

---@param spec table
local function to_pack(spec)
  return { src = spec.src, name = spec.name, version = spec.version }
end

---Installe, charge puis configure une liste de specs.
---Une spec marquée `load = false` est seulement maintenue à jour sur le
---disque : son plugin/ n'est jamais sourcé et sa config n'est pas appliquée.
---C'est ce qui permet de n'utiliser un dépôt que pour un binaire qu'il livre.
---@param specs table[]
function M.add(specs)
  local loaded, on_disk = {}, {}
  for _, spec in ipairs(specs) do
    table.insert(spec.load == false and on_disk or loaded, spec)
  end

  if #on_disk > 0 then
    vim.pack.add(vim.tbl_map(to_pack, on_disk), { load = false })
  end
  vim.pack.add(vim.tbl_map(to_pack, loaded))

  vim.iter(loaded):each(apply)
end

---Toutes les specs de lua/plugins/, par ordre alphabétique pour que l'ordre
---de configuration soit reproductible.
---@return table[]
function M.all()
  local dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "plugins")
  local names = {}

  for entry, kind in vim.fs.dir(dir) do
    if kind == "file" and entry:sub(-4) == ".lua" then
      names[#names + 1] = entry:sub(1, -5)
    end
  end
  table.sort(names)

  return vim.tbl_map(function(name)
    return require("plugins." .. name)
  end, names)
end

return M
