local M = {}

---@return vim.lsp.Client?
local function client()
  return vim.lsp.get_clients({ bufnr = 0, name = "tinymist" })[1]
end

---@param command string
---@param arguments any[]
---@param on_success? fun(result: any)
local function request(command, arguments, on_success)
  local c = client()
  if not c then
    vim.notify("Tinymist n'est pas attaché", vim.log.levels.ERROR)
    return
  end

  c:request("workspace/executeCommand", {
    command = command,
    arguments = arguments,
  }, function(err, result)
    vim.schedule(function()
      if err then
        vim.notify(("%s : %s"):format(command, err.message or tostring(err)), vim.log.levels.ERROR)
      elseif on_success then
        on_success(result)
      end
    end)
  end)
end

function M.compile()
  request("tinymist.exportPdf", { vim.api.nvim_buf_get_name(0) }, function(result)
    vim.notify("PDF exporté : " .. ((result or {}).path or "?"))
  end)
end

--- Seul état conservé : le chemin épinglé, pour que la commande fasse bascule.
--- Il ne sert à rien d'autre — compile et view portent sur le buffer courant.
---@type string?
local pinned = nil

--- Épingle le buffer courant comme document principal, ou le détache s'il
--- l'est déjà. vim.NIL s'encode en `null`, que tinymist lit comme un détachement.
function M.pin()
  local path = vim.api.nvim_buf_get_name(0)
  local detach = pinned == path

  request("tinymist.pinMain", { detach and vim.NIL or path }, function()
    pinned = (not detach) and path or nil
    vim.notify(detach and "Document principal détaché" or ("Document principal : " .. path))
  end)
end

function M.view(viewer)
  local source = vim.api.nvim_buf_get_name(0)
  local pdf = source:gsub("%.typ$", ".pdf")
  if vim.fn.filereadable(pdf) ~= 1 then
    vim.notify("PDF introuvable : " .. pdf .. "\nCompiler d'abord (<localleader>c)", vim.log.levels.ERROR)
    return
  end
  vim.system({ viewer or "zathura", pdf }, { detach = true, cwd = vim.fs.dirname(source) })
end

return M
