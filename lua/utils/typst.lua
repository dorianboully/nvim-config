local TEMPLATES_PATH = "~/.local/share/typst/packages/local"
local LOCK_FILE = ".typstmain"
local M = {}

--- Get the tinymist LSP client for the current buffer
---@return vim.lsp.Client?
local function get_client()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = "tinymist" })
  return clients[1]
end

--- Find the project root by searching upward for root markers
---@param path string
---@return string
local function find_root(path)
  local dir = vim.fn.fnamemodify(path, ":p:h")
  local found = vim.fs.find({ "typst.toml", ".git", "main.typ" }, { path = dir, upward = true })
  if #found > 0 then
    return vim.fs.dirname(found[1])
  end
  return dir
end

--- Get the lock file path for a given buffer path
---@param bufpath string
---@return string
local function get_lock_path(bufpath)
  return find_root(bufpath) .. "/" .. LOCK_FILE
end

--- Write the main file path to the project lock file
---@param main_path string
local function write_lock(main_path)
  local lock_path = get_lock_path(main_path)
  local f = io.open(lock_path, "w")
  if f then
    f:write(main_path .. "\n")
    f:close()
  end
end

--- Read the main file path from the project lock file
---@param bufpath string
---@return string?
local function read_lock(bufpath)
  local lock_path = get_lock_path(bufpath)
  local f = io.open(lock_path, "r")
  if f then
    local main = f:read("*l")
    f:close()
    if main and main ~= "" and vim.fn.filereadable(main) == 1 then
      return main
    end
  end
  return nil
end

--- Get the main file for the current buffer.
--- Resolution order: pinned path > lock file > given path.
---@param bufpath string?
---@return string
M.getMainFile = function(bufpath)
  bufpath = bufpath or vim.api.nvim_buf_get_name(0)
  return M._pinnedPath or read_lock(bufpath) or bufpath
end

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

--- Initialize a typst project
--- @param template string?
--- @param name string?
--- @param cwd string?
--- @return nil
M.typstInit = function(template, name, cwd)
  name = name or getName()
  cwd = cwd or vim.fn.getcwd(0)

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

--- Export the current document as PDF via tinymist.
--- Writes a lock file with the main path when no temporary pin is active.
M.compile = function()
  local client = get_client()
  if not client then
    vim.notify("tinymist not attached", vim.log.levels.ERROR)
    return
  end

  local path = M.getMainFile()

  -- Persist the main file in the lock file only when not using a temporary pin
  if not M._pinnedPath then
    write_lock(path)
  end

  client:request("workspace/executeCommand", {
    command = "tinymist.exportPdf",
    arguments = { path },
  }, function(err)
    vim.schedule(function()
      if err then
        vim.notify("Export failed: " .. tostring(err.message or err), vim.log.levels.ERROR)
      else
        vim.notify("PDF exported", vim.log.levels.INFO)
      end
    end)
  end)
end

--- Toggle pin/unpin the main file for multi-file projects
M._pinnedPath = nil
M.togglePin = function()
  local client = get_client()
  if not client then
    vim.notify("tinymist not attached", vim.log.levels.ERROR)
    return
  end

  local shouldPin = M._pinnedPath == nil
  -- vim.NIL encodes as JSON null, telling tinymist to unpin the main file
  local bufname = vim.api.nvim_buf_get_name(0)
  local path = shouldPin and bufname or vim.NIL

  client:request("workspace/executeCommand", {
    command = "tinymist.pinMain",
    arguments = { path },
  }, function(err)
    vim.schedule(function()
      if err then
        vim.notify("Pin failed: " .. tostring(err.message or err), vim.log.levels.ERROR)
      else
        M._pinnedPath = shouldPin and bufname or nil
        local msg = shouldPin and ("Pinned: " .. bufname) or "Unpinned main file"
        vim.notify(msg, vim.log.levels.INFO)
      end
    end)
  end)
end

M.view = function(viewer, file)
  viewer = viewer or "zathura"
  local input = M.getMainFile()
  file = file or input:gsub(".typ", ".pdf")
  local cwd = vim.fn.fnamemodify(input, ":h")

  if not vim.fn.filereadable(file) then
    vim.notify("File '" .. file .. "' not readable.", vim.log.levels.ERROR)
  end

  vim.system({ viewer, file }, { detach = true, cwd = cwd })
end

return M
