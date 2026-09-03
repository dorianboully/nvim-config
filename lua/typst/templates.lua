local TEMPLATES_PATH = "~/.local/share/typst/packages/local"

local M = {}

local function directories(path)
  local ok, entries = pcall(vim.fn.readdir, path)
  if not ok then return {} end
  return vim.tbl_filter(function(entry)
    return vim.fn.isdirectory(vim.fs.joinpath(path, entry)) == 1
  end, entries)
end

local function templates()
  local path = vim.fs.normalize(vim.fn.expand(TEMPLATES_PATH))
  local result = {}
  for _, name in ipairs(directories(path)) do
    for _, version in ipairs(directories(vim.fs.joinpath(path, name))) do
      result[#result + 1] = {
        name = name,
        version = version,
        value = ("@local/%s:%s"):format(name, version),
      }
    end
  end
  table.sort(result, function(a, b)
    return a.name == b.name and a.version < b.version or a.name < b.name
  end)
  return result
end

local function select_template()
  local thread = assert(coroutine.running(), "template selection must run in a coroutine")
  vim.ui.select(templates(), {
    prompt = "Typst template",
    format_item = function(item) return ("%s (v:%s)"):format(item.name, item.version) end,
  }, function(item) coroutine.resume(thread, item and item.value or nil) end)
  return coroutine.yield()
end

function M.init(template, name, cwd)
  name = name or vim.trim(vim.fn.input("Typst project name: "))
  template = template or select_template()
  cwd = cwd or vim.fn.getcwd(0)
  if not template or template == "" or name == "" then return end

  vim.notify(("Création de %s dans %s depuis %s"):format(name, cwd, template))
  vim.system({ "typst", "init", template, name }, { cwd = cwd }, require("utils.system").onExit)
end

return M
