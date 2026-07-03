-- Entry point when running inside vscode-neovim (vim.g.vscode is set).

require("config.options")        -- mapleader/maplocalleader live here; UI opts are inert headless
require("config.keymaps")        -- most maps work as-is under vscode-neovim
require("config.vscode.keymaps") -- VSCode overlay last, so it overrides shared maps