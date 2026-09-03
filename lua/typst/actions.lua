local M = {}

local function buffer_path()
  return vim.api.nvim_buf_get_name(0)
end

local function request(command, arguments, success)
  local client = vim.lsp.get_clients({ bufnr = 0, name = "tinymist" })[1]
  if not client then
    vim.notify("Tinymist n'est pas attaché", vim.log.levels.ERROR)
    return
  end

  client:request("workspace/executeCommand", {
    command = command,
    arguments = arguments,
  }, function(err)
    vim.schedule(function()
      if err then
        vim.notify(("%s : %s"):format(command, err.message or tostring(err)), vim.log.levels.ERROR)
      elseif success then
        success()
      end
    end)
  end)
end

function M.compile()
  request("tinymist.exportPdf", { buffer_path() }, function()
    vim.notify("PDF exporté")
  end)
end

function M.pin()
  local path = buffer_path()
  request("tinymist.pinMain", { path }, function()
    vim.notify("Document principal : " .. path)
  end)
end

function M.view(viewer)
  local source = buffer_path()
  local pdf = source:gsub("%.typ$", ".pdf")
  if vim.fn.filereadable(pdf) ~= 1 then
    vim.notify("PDF introuvable : " .. pdf, vim.log.levels.ERROR)
    return
  end
  vim.system({ viewer or "zathura", pdf }, { detach = true, cwd = vim.fs.dirname(source) })
end

return M
