-- Entry point when running inside vscode-neovim (vim.g.vscode is set).

-- vimtex: text objects/surround only; LaTeX Workshop owns compile/view.
-- Must be set before packAddSpecs loads vimtex.
vim.g.vimtex_compiler_enabled = 0
vim.g.vimtex_view_enabled = 0
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_syntax_enabled = 0 -- highlighting is VSCode's job

require("config.options")        -- mapleader/maplocalleader live here; UI opts are inert headless
require("config.keymaps")        -- most maps work as-is under vscode-neovim
require("config.commands")       -- typst textwidth autocmd, TypstInit/TypstDiagram, yank highlight
require("config.treesitter")     -- registers/starts the typst parser for am/im textobjects
require("config.vscode.keymaps") -- VSCode overlay last, so it overrides shared maps
