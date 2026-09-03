local M = {}

-- tinymist.exportPdf compile exactement le chemin qu'on lui passe, et pinMain
-- n'a aucun effet dessus — vérifié : épingler main.typ puis exporter en étant
-- dans chapitres/ch1.typ produit chapitres/ch1.pdf. L'éditeur doit donc retenir
-- lui-même le document principal, sinon compile et view portent sur le
-- sous-fichier ouvert. Indexé par racine de projet, pour que deux projets
-- ouverts dans la même session ne se mélangent pas.
---@type table<string, string>
local main_files = {}

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

--- Document sur lequel portent compile et view : le principal épinglé pour ce
--- projet, à défaut le buffer courant.
---@return string
local function target()
  local c = client()
  local root = c and c.root_dir
  return (root and main_files[root]) or vim.api.nvim_buf_get_name(0)
end

function M.compile()
  request("tinymist.exportPdf", { target() }, function(result)
    vim.notify("PDF exporté : " .. ((result or {}).path or "?"))
  end)
end

--- Épingle le buffer courant comme document principal, ou le détache s'il
--- l'est déjà. vim.NIL s'encode en `null`, que tinymist lit comme un détachement.
function M.pin()
  local c = client()
  if not c then
    vim.notify("Tinymist n'est pas attaché", vim.log.levels.ERROR)
    return
  end

  local root = c.root_dir or ""
  local path = vim.api.nvim_buf_get_name(0)
  local detach = main_files[root] == path

  request("tinymist.pinMain", { detach and vim.NIL or path }, function()
    main_files[root] = (not detach) and path or nil
    vim.notify(detach and "Document principal détaché" or ("Document principal : " .. path))
  end)
end

function M.view(viewer)
  local source = target()
  local pdf = source:gsub("%.typ$", ".pdf")
  if vim.fn.filereadable(pdf) ~= 1 then
    vim.notify("PDF introuvable : " .. pdf .. "\nCompiler d'abord (<localleader>c)", vim.log.levels.ERROR)
    return
  end
  vim.system({ viewer or "zathura", pdf }, { detach = true, cwd = vim.fs.dirname(source) })
end

return M
