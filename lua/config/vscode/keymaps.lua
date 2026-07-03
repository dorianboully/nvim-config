-- Overrides of shared keymaps whose targets are nvim-only (netrw, :resize,
-- vim.lsp, snacks pickers) with their VSCode workbench equivalents.

local vscode = require("vscode") -- bundled with vscode-neovim
local map = vim.keymap.set

local function act(name)
  return function() vscode.action(name) end
end