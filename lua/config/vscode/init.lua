-- Entry point when running inside vscode-neovim (vim.g.vscode is set).

require("config.options")        -- mapleader/maplocalleader live here; UI opts are inert headless
require("config.keymaps")        -- most maps work as-is under vscode-neovim
require("config.treesitter")     -- starts the typst parser; required by ts_textobjects below
require("config.vscode.keymaps") -- VSCode overlay last, so it overrides shared maps

-- Explicit opt-in (not the old blanket exclude-list): only load what am/im need.
-- Both work headless; queries/typst/textobjects.scm (@math.outer/@math.inner) is
-- already on the runtimepath since it lives in this config's own queries/ dir.
require("utils.pack").packAddSpecs({
  require("plugins.nvim-treesitter"),
  require("plugins.ts_textobjects"),
})