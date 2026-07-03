-- Overrides of shared keymaps whose targets are nvim-only (netrw, :resize,
-- vim.lsp, snacks pickers) with their VSCode workbench equivalents.

local vscode = require("vscode") -- bundled with vscode-neovim
local map = vim.keymap.set

local function act(name)
  return function() vscode.action(name) end
end

map("n", "<leader>e", act("workbench.view.explorer"), { desc = "Open explorer view" })
map("n", "<leader>E", act("workbench.files.action.showActiveFileInExplorer"), { desc = "Reveal file in explorer" })

map("n", "<leader>bf", act("editor.action.formatDocument"), { desc = "Format current buffer" })

-- Buffers -> editor tabs
map("n", "<S-h>", act("workbench.action.previousEditorInGroup"), { desc = "Prev Buffer" })
map("n", "<S-l>", act("workbench.action.nextEditorInGroup"), { desc = "Next Buffer" })
map("n", "<leader>bd", act("workbench.action.closeActiveEditor"), { desc = "Close Editor" })
map("n", "<leader>bD", act("workbench.action.closeEditorsInGroup"), { desc = "Close Editor Group" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", act("workbench.action.increaseViewHeight"), { desc = "Increase Window Height" })
map("n", "<C-Down>", act("workbench.action.decreaseViewHeight"), { desc = "Decrease Window Height" })
map("n", "<C-Left>", act("workbench.action.decreaseViewWidth"), { desc = "Decrease Window Width" })
map("n", "<C-Right>", act("workbench.action.increaseViewWidth"), { desc = "Increase Window Width" })

-- Snacks-picker replacements (minimal set)
map("n", "<leader>ff", act("workbench.action.quickOpen"), { desc = "Find Files" })
map("n", "<leader>fb", act("workbench.action.showAllEditors"), { desc = "Buffers" })
map("n", "<leader>sg", act("workbench.action.findInFiles"), { desc = "Grep" })
map("n", "<leader>/", act("workbench.action.findInFiles"), { desc = "Grep" })
map("n", "<leader>sd", act("workbench.actions.view.problems"), { desc = "Diagnostics" })
map("n", "<leader>ss", act("workbench.action.gotoSymbol"), { desc = "Document Symbols" })

-- Typst: replaces the on_attach maps from lsp/tinymist.lua and typst-preview.nvim,
-- both handled by the tinymist extension in VSCode.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typst",
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map("n", "<localleader>c", act("tinymist.exportCurrentPdf"), vim.tbl_extend("force", opts, { desc = "Compile pdf" }))
    map("n", "<localleader>v", act("tinymist.showPdf"), vim.tbl_extend("force", opts, { desc = "View pdf" }))
    map("n", "<localleader>m", act("tinymist.pinMainToCurrent"), vim.tbl_extend("force", opts, { desc = "Pin main file" }))
    map("n", "<localleader>M", act("tinymist.unpinMain"), vim.tbl_extend("force", opts, { desc = "Unpin main file" }))
    map("n", "<localleader>p", act("typst-preview.preview"), vim.tbl_extend("force", opts, { desc = "Toggle preview" }))
  end,
})
