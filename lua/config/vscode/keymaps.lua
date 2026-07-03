-- Overrides of shared keymaps whose targets are nvim-only (netrw, :resize,
-- vim.lsp, snacks pickers) with their VSCode workbench equivalents.

local vscode = require("vscode") -- bundled with vscode-neovim
local map = vim.keymap.set

local function act(name, args)
  return function() vscode.action(name, args and { args = args }) end
end

-- Typst: mirror <leader>t{d,i} from config/keymaps.lua (which call the nvim-only
-- :TypstDiagram/:TypstInit user commands, unavailable under vscode since
-- config/commands.lua isn't loaded here) and add {p,c,v}, all backed by the
-- tinymist/typst-preview extensions.
map("n", "<leader>td", act("vscode.open", "https://q.uiver.app/"), { desc = "Open web diagram helper" })
map("n", "<leader>ti", act("tinymist.initTemplate"), { desc = "Init typst project" })
map("n", "<leader>tp", act("typst-preview.preview"), { desc = "Toggle preview" })
map("n", "<leader>tc", act("tinymist.exportCurrentPdf"), { desc = "Compile pdf" })
map("n", "<leader>tv", act("tinymist.showPdf"), { desc = "View pdf" })