local CONFIG_FILE = "project.json"
local TEMPLATES_PATH = "~/.local/share/typst/packages/local"
local M = {}

--- Return a template from local templates
--- (from "~/.local/share/typst/packages/")
--- using snacks picker if available or manual
--- input. The return value is a string of the form
--- "@local/<template>:<version>" that will be passed
--- to typst.
---@return string
local function pickTemplate()
  local local_packages = vim.fs.normalize(vim.fn.expand(TEMPLATES_PATH))
  local function list_dirs(path)
    local ok, entries = pcall(vim.fn.readdir, path)
    if not ok then
      return {}
    end
    return vim.tbl_filter(function(entry)
      return vim.fn.isdirectory(path .. "/" .. entry) == 1
    end, entries)
  end

  ---@class TypstTemplate
  ---@field template string
  ---@field version string
  ---@field value string
  local templates = {}
  if vim.fn.isdirectory(local_packages) == 1 then
    for _, name in ipairs(list_dirs(local_packages)) do
      for _, version in ipairs(list_dirs(local_packages .. "/" .. name)) do
        templates[#templates + 1] = {
          template = name,
          version = version,
          value = string.format("@local/%s:%s", name, version),
        }
      end
    end
  end

  table.sort(templates, function(a, b)
    if a.template == b.template then
      return a.version < b.version
    end
    return a.template < b.template
  end)



  if vim.ui then
    local co = assert(coroutine.running())

    local cb = function(item)
      coroutine.resume(co, item and item.value or nil)
    end

    vim.ui.select(
      templates,
      {
        prompt = "Typst template",
        format_item = function(item)
          return string.format("%s (v:%s)", item.template, item.version)
        end,
      },
      cb
    )

    if co then
      local choice = coroutine.yield()
      vim.print("choice: " .. choice)
      return choice
    end
  end

  local ok_input, input = pcall(vim.fn.input, "Typst template (@local/<name>:<version>): ", "@local/")
  if ok_input then
    return vim.trim(input)
  end

  return ""
end

--- Return the name of the project to be created
--- from user input.
--- @return string
local function getName()
  local ok, input = pcall(vim.fn.input, "Typst project name: ", "")
  if ok then
    return vim.trim(input)
  end
  return ""
end

--- Return the directory in which the "typst init"
--- command should be called. The path should be inferred
--- depending on the buffer:
--- a) If we are inside snacks file explorer, it should return
--- the directory corresponding to the line currently hovered
--- b) If the current bufer is a file, return its parent folder
--- c) Else, return nil
--- @return string | nil
local function getCwd()
  local function explorer_dir()
    local ok, snacks = pcall(require, "snacks")
    if not ok or not snacks.picker then
      vim.notify(snacks, vim.log.levels.INFO)
      return
    end

    local explorers = snacks.picker.get({ source = "explorer" })
    for _, picker in ipairs(explorers) do
      if picker:is_focused() then
        local dir = picker:dir()
        if dir and dir ~= "" then
          return dir
        end
      end
    end
  end

  local dir = explorer_dir()
  if dir and dir ~= "" then
    return dir
  end

  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname ~= "" then
    local parent = vim.fn.fnamemodify(bufname, ":p:h")
    if parent ~= "" then
      return parent
    end
  end
end

--- Initialize a typst project
--- @param template string?
--- @param name string?
--- @param cwd string?
--- @return nil
M.typstInit = function(template, name, cwd)
  name = name or getName()
  cwd = cwd or getCwd()

  template = template or pickTemplate()

  vim.print(template)

  if not template or template == "" then
    vim.notify("Failed to choose template", vim.log.levels.ERROR)
    return
  end

  vim.notify(table.concat({
    "Creating new typst project:",
    "name: " .. name,
    "location: " .. cwd,
    "template: " .. template,
  }, "\n"), vim.log.levels.INFO)

  vim.system(
    { "typst", "init", template, name },
    { detach = true, cwd = cwd },
    require("utils.system").onExit
  )
end

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

M.initProject = function(bufnr)
  local root = findRoot(bufnr)
  local opts = readJson(findRoot(bufnr) .. "/" .. CONFIG_FILE)
  opts.root = root
  return TypstProj:new(opts)
end

return M
