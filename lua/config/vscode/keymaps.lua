-- Overrides of shared keymaps whose targets are nvim-only (netrw, :resize,
-- vim.lsp, snacks pickers) with their VSCode workbench equivalents.

local vscode = require("vscode") -- bundled with vscode-neovim
local map = vim.keymap.set

local function act(name, args)
  if args ~= nil and type(args) ~= "table" then
    args = { args }
  end
  return function() vscode.action(name, args and { args = args }) end
end

-- These mirror the Neovim actions, but remain local to Typst buffers.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  group = vim.api.nvim_create_augroup("vscode.typst", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map("n", "<localleader>d", act("vscode.open", "https://q.uiver.app/"), opts)
    map("n", "<localleader>i", act("tinymist.initTemplate"), opts)
    map("n", "<localleader>m", act("tinymist.pinMainToCurrent"), opts)
    map("n", "<localleader>p", act("typst-preview.browser"), opts)
    map("n", "<localleader>c", act("tinymist.exportCurrentPdf"), opts)
    map("n", "<localleader>v", act("tinymist.showPdf"), opts)
  end,
})
