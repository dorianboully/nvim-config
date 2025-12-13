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

M.compile = function(cmd)
  cmd = cmd or "compile"

  local input = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.fnamemodify(input, ":h")

  local argv = {
    "typst",
    cmd,
    input
  }

  vim.system(argv, { detach = true, text = true, cwd = cwd },
    require("utils.system").onExit)
end

M.view = function(viewer, file)
  viewer = viewer or "zathura"
  local input = vim.api.nvim_buf_get_name(0)
  file = file or input:gsub(".typ", ".pdf")
  local cwd = vim.fn.fnamemodify(input, ":h")

  if not vim.fn.filereadable(file) then
    vim.notify("File '" .. file .. "' not readable.", vim.log.levels.ERROR)
  end

  vim.system({ viewer, file }, { detach = true, cwd = cwd })
end

return M
