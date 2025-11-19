vim.api.nvim_create_user_command("PackClean", require("utils.pack").packClean, {})
vim.api.nvim_create_user_command("PackListInactive", function()
  vim.print(require("utils.pack").getInactivePackages())
end, {})

-- Detect rc filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*rc",
  callback = function()
    if vim.bo.filetype == "" then
      vim.bo.filetype = "sh"
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex", "typst" },
  callback = function(args)
    vim.bo[args.buf].textwidth = 80
    vim.opt_local.breakindent = true
  end
})

--- Return a template from local templates
--- (from "~/.local/share/typst/packages/")
--- using snacks picker if available or manual
--- input. The return value is a string of the form
--- "@local/<template>:<version>" that will be passed
--- to typst.
---@return string
local function pickTemplate()
  local template = ""
  local local_packages = vim.fs.normalize(vim.fn.expand("~/.local/share/typst/packages/local"))
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

  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.picker and snacks.picker.select and #templates > 0 then
    local choice
    local done = false
    snacks.picker.select(
      templates,
      {
        prompt = "Typst template",
        format_item = function(item)
          return string.format("%s (%s)", item.template, item.version)
        end,
      },
      function(item)
        choice = item and item.value or nil
        done = true
      end
    )
    vim.wait(24 * 60 * 60 * 1000, function()
      return done
    end, 100)
    if choice and choice ~= "" then
      return choice
    end
  end

  local default = templates[1] and templates[1].value or "@local/"
  local ok_input, input = pcall(vim.fn.input, "Typst template (@local/<name>:<version>): ", default)
  if ok_input then
    template = vim.trim(input)
  end
  return template
end

--- Return the name of the project to be created
--- from user input.
--- @return string
local function getName()
  local name = ""
  local default = vim.fn.expand("%:t:r")
  if default == "" then
    default = vim.fs.basename(vim.loop.cwd() or vim.fn.getcwd())
  end
  local ok, input = pcall(vim.fn.input, "Typst project name: ", default)
  if ok then
    name = vim.trim(input)
  end
  return name
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
      return nil
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

local function typstInit(template, name, cwd)
  template = template or pickTemplate()
  name = name or getName()
  cwd = cwd or getCwd()

  vim.system(
    { "typst", "init", template, name },
    { detach = true, cwd = cwd},
    require("utils.system").onExit()
  )
end

vim.api.nvim_create_user_command("TypstInit", typstInit, {})
