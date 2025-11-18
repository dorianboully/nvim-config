local M = {}

local isInactive = function(package)
  return not package.active
end

local getName = function(package)
  return package.spec.name
end

---Check if package is loaded
---@param name string
---@return boolean
M.isLoaded = function(name)
  return package.loaded[name] ~= nil
end

M.getInactivePackages = function()
  return vim.iter(vim.pack.get())
      :filter(isInactive)
      :map(getName)
      :totable()
end

M.packClean = function()
  vim.pack.del(M.getInactivePackages())
end

local getPackArg = function(spec)
  if spec.enable == nil or spec.enable then
    return { src = spec.src, version = spec.version, name = spec.name }
  end
end

local setKeys = function(keys)
  require("utils.keymap").mapKeys(keys)
end

local configure = function(spec)
  local config = spec.config
  local opts = spec.opts
  if config == true then
    local ok, plugin = pcall(require, spec.name)
    if ok then plugin.setup(opts) end
  elseif not not config and type(config) == "function" then
    config(opts)
  end
end

M.packAddSpecs = function(specs)
  vim.pack.add(vim.iter(specs):map(getPackArg):totable())

  vim.iter(specs):each(function(spec)
    configure(spec)
    setKeys(spec.keys)
  end
  )
end

local matches = function(str, patterns)
  return vim.iter(patterns):any(function(pattern) return str:sub(1, #pattern) == pattern end)
end

M.getSpecs = function(dir, filter)
  return vim.iter(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/" .. dir))
      :map(function(str) return (not matches(str, filter)) and require(dir .. "." .. str:gsub(".lua", "")) or nil end)
      :totable()
end

return M
