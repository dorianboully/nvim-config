vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.cursorline = true     -- Enable highlighting of the current line
opt.ruler = false         -- Disable the default ruler
opt.signcolumn = "yes"    -- Always show the signcolumn, otherwise it would shift the text each time
opt.relativenumber = true -- Relative line numbers
opt.number = true         -- Show line number
opt.scrolloff = 8         -- Lines of context
opt.sidescrolloff = 8     -- Columns of context
opt.winborder = "single"
opt.expandtab = true      -- Use spaces instead of tabs
opt.wrap = false          -- Disable line wrap
opt.shiftwidth = 2        -- Size of an indent
opt.tabstop = 2           -- Number of spaces tabs count for
opt.smartindent = true    -- Insert indents automatically
opt.ignorecase = true     -- Case insensitive search
opt.smartcase = true      -- Don't ignore case with capitals
opt.completeopt = "noinsert,menuone,popup"

opt.swapfile = false
opt.backup = false
opt.undofile = true
