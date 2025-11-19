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
  -- TODO : complete this function
  return template
end

--- Return the name of the project to be created
--- from user input.
--- @return string
local function getName()
  local name = ""
  -- TODO : complete this function
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
  -- TODO : complete this function
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
