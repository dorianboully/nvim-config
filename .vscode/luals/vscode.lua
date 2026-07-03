---@meta

---@class vscode.ActionOptions
---@field args? any[]
---@field callback? fun(err?: any, result?: any)

---@class vscode
local M = {}

---Runs a VS Code command from vscode-neovim.
---@param name string
---@param opts? vscode.ActionOptions
function M.action(name, opts) end

return M
