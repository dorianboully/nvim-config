local TEMPLATES_PATH = "~/.local/share/typst/packages/local"
local LOCK_FILE = "tinymist.lock"
local M = {}

--- Get the tinymist LSP client for the current buffer
---@return vim.lsp.Client?
local function get_client()
  local clients = vim.lsp.get_clients({ bufnr = 0, name = "tinymist" })
  return clients[1]
end

--- Find tinymist.lock by searching upward from a path
---@param bufpath string
---@return string? lock_path, string? lock_dir
local function find_lock(bufpath)
  local dir = vim.fn.fnamemodify(bufpath, ":p:h")
  local found = vim.fs.find(LOCK_FILE, { path = dir, upward = true })
  if #found > 0 then
    return found[1], vim.fs.dirname(found[1])
  end
  return nil, nil
end

--- Read the main file from a tinymist.lock file.
--- Picks the route with the highest priority and resolves the matching
--- document's main path to an absolute path.
---@param bufpath string
---@return string?
local function read_lock_main(bufpath)
  local lock_path, lock_dir = find_lock(bufpath)
  if not lock_path or not lock_dir then
    return nil
  end

  local f = io.open(lock_path, "r")
  if not f then
    return nil
  end
  local content = f:read("*a")
  f:close()

  -- Line-by-line parse: collect [[document]] and [[route]] entries
  local section, docs, routes = nil, {}, {}
  local cur = {}
  for line in content:gmatch("[^\n]+") do
    local header = line:match("^%[%[(%w+)%]%]$")
    if header then
      if section and cur.id then
        if section == "document" then
          docs[#docs + 1] = cur
        elseif section == "route" then
          routes[#routes + 1] = cur
        end
      end
      section = header
      cur = {}
    elseif section then
      local key, val = line:match('^(%S+)%s*=%s*"([^"]-)"')
      if key then
        cur[key] = val
      end
      local knum, vnum = line:match("^(%S+)%s*=%s*(%d+)%s*$")
      if knum then
        cur[knum] = tonumber(vnum)
      end
    end
  end
  if section and cur.id then
    if section == "document" then
      docs[#docs + 1] = cur
    elseif section == "route" then
      routes[#routes + 1] = cur
    end
  end

  -- Find the route with the highest priority
  local best_id, best_priority = nil, -1
  for _, r in ipairs(routes) do
    local p = r.priority or 0
    if p > best_priority then
      best_id = r.id
      best_priority = p
    end
  end

  if not best_id then
    return nil
  end

  -- Find the matching document's main field
  local main_ref
  for _, d in ipairs(docs) do
    if d.id == best_id then
      main_ref = d.main
      break
    end
  end

  if not main_ref then
    return nil
  end

  -- Resolve "file:xxx" to an absolute path relative to the lock directory
  local rel = main_ref:gsub("^file:", "")
  local abs = vim.fs.normalize(lock_dir .. "/" .. rel)
  if vim.fn.filereadable(abs) == 1 then
    return abs
  end
  return nil
end

--- Get the main file for the current buffer.
--- Resolution order: pinned path > tinymist.lock > given path.
---@param bufpath string?
---@return string
M.getMainFile = function(bufpath)
  bufpath = bufpath or vim.api.nvim_buf_get_name(0)
  return M._pinnedPath or read_lock_main(bufpath) or bufpath
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

--- Export the current document as PDF via tinymist
M.compile = function()
  local client = get_client()
  if not client then
    vim.notify("tinymist not attached", vim.log.levels.ERROR)
    return
  end

  local path = M.getMainFile()

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
