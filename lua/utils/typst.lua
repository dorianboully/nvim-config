local CONFIG_FILE = "project.json"

local TypstProj = {}
TypstProj.__index = TypstProj

function TypstProj:new(opts)
  opts = opts or {}

  return setmetatable({
    compiler = opts.compiler or "typst",
    options = opts.options or {},
    input = opts.input or "main.typ",
    output = (opts.output and opts.output ~= "") and opts.output or nil,
    viewer = opts.options and opts.options.open or nil,
    root = opts.root
  }, TypstProj)
end

local function readJson(path)
  local f = io.open(path, "r")
  if not f then
    vim.notify("No " .. CONFIG_FILE .. " found", vim.log.levels.INFO)
    return nil
  end
  local content = f:read("*a")
  f:close()
  local ok, decoded = pcall(vim.fn.json_decode, content)
  if not ok then
    vim.notify("Error decoding " .. CONFIG_FILE, vim.log.levels.INFO)
    return nil
  end
  return decoded
end

local function optToString(optName, value)
  return { "--" .. optName, value }
end

---@param cmd string
---@return string[]
function TypstProj:toSystemCmd(cmd)
  if cmd ~= "compile" and cmd ~= "watch" then
    vim.notify("Command not supported : " .. cmd, "error")
    return {}
  end

  local sysCmd = {
    self.compiler,
    cmd,
    vim.iter(pairs(self.options)):map(optToString):totable(),
    self.input,
    self.output,
  }

  return vim.iter(sysCmd):flatten(2):totable()
end

function TypstProj:compile(cmd)
  cmd = cmd or "compile"

  local argv = self:toSystemCmd(cmd)

  if not argv or #argv == 0 then
    vim.notify("Command line is empty.", vim.log.levels.WARN)
    return
  end

  vim.system(argv, { detach = true, text = true, cwd = self.root }, require("utils.system").onExit)
end

function TypstProj:view()
  local input = self.input
  if not input then
    vim.notify("No input file selected", vim.log.levels.ERROR)
  end

  local viewer = self.viewer
  if not viewer then
    vim.notify("No viewer selected", vim.log.levels.ERROR)
  end

  local format = self.options.format or "pdf"

  local default = input:gsub(".typ", "." .. format)

  local output = (self.output and not (self.output == "")) and self.output or default

  if not vim.fn.filereadable(output) then
    vim.notify("File '" .. output .. "' not readable.", vim.log.levels.ERROR)
  end

  vim.system({ viewer, output }, { detach = true, cwd = self.root })
end

local findRoot = function(bufnr)
  return vim.fs.root(0, { CONFIG_FILE }) or
      vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h")
end

return {
  initProject = function(bufnr)
    local root = findRoot(bufnr)
    local opts = readJson(findRoot(bufnr) .. "/" .. CONFIG_FILE)
    opts.root = root
    return TypstProj:new(opts)
  end
}
