local project = require("typst.project")

local M = {}

---@param bufnr? integer
---@return vim.lsp.Client?
local function client(bufnr)
  return vim.lsp.get_clients({ bufnr = bufnr or 0, name = "tinymist" })[1]
end

---@param c vim.lsp.Client
---@param command string
---@param arguments any[]
---@param on_success? fun(result: any)
local function execute(c, command, arguments, on_success)
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

---@param command string
---@param arguments any[]
---@param on_success? fun(result: any)
local function request(command, arguments, on_success)
  local c = client()
  if not c then
    vim.notify("Tinymist n'est pas attaché", vim.log.levels.ERROR)
    return
  end

  execute(c, command, arguments, on_success)
end

--- Document que visent compile et view : le principal du projet, pas le
--- chapitre ouvert. tinymist.exportPdf compile exactement le chemin qu'on lui
--- passe, sans consulter l'épinglage — vérifié dans ses sources.
---@param bufnr? integer
---@return string
local function main(bufnr)
  return project.main(vim.api.nvim_buf_get_name(bufnr or 0))
end

function M.compile()
  request("tinymist.exportPdf", { main() }, function(result)
    vim.notify("PDF exporté : " .. ((result or {}).path or "?"))
  end)
end

function M.view(viewer)
  local source = main()
  local pdf = source:gsub("%.typ$", ".pdf")
  if vim.fn.filereadable(pdf) ~= 1 then
    vim.notify("PDF introuvable : " .. pdf .. "\nCompiler d'abord (<localleader>c)", vim.log.levels.ERROR)
    return
  end
  vim.system({ viewer or "zathura", pdf }, { detach = true, cwd = vim.fs.dirname(source) })
end

--- Épinglage déjà envoyé, par client. C'est un état du serveur et non du
--- buffer : tinymist n'a qu'un document principal à la fois. Indexer par client
--- suffit à le réenvoyer si le serveur redémarre, puisqu'il change d'identifiant.
---@type table<integer, string>
local pinned = {}

--- Aligne l'épinglage du serveur sur le principal du buffer. Sans lui, tinymist
--- prend pour entrée le fichier qu'on ouvre, et un chapitre se compile hors du
--- contexte de son document : diagnostics fantômes et complétion amputée.
---@param bufnr? integer
function M.sync(bufnr)
  local c = client(bufnr)
  local target = c and main(bufnr)
  if not target or target == "" or pinned[c.id] == target then
    return
  end

  execute(c, "tinymist.pinMain", { target }, function()
    pinned[c.id] = target
  end)
end

--- Impose le buffer courant comme principal de son projet, quand l'entrée ne
--- s'appelle pas main.typ ou pour travailler un fichier isolément.
function M.pin()
  local path = vim.api.nvim_buf_get_name(0)
  project.force(path)
  vim.notify("Document principal : " .. path)
  M.sync()
end

--- Rend le projet à la détection par convention.
function M.unpin()
  local detected = project.release(vim.api.nvim_buf_get_name(0))
  vim.notify("Document principal détecté : " .. detected)
  M.sync()
end

-- L'épinglage vit dans le serveur : changer de fenêtre, ou de projet, demande
-- de le refaire. Le groupe est créé au premier require de ce module, donc au
-- premier fichier typst ouvert, et une seule fois.
vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
  group = vim.api.nvim_create_augroup("typst.main", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].filetype == "typst" then
      M.sync(args.buf)
    end
  end,
})

return M
