-- Socle : rien ici ne dépend d'un plugin.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local o = vim.o

-- ── Interface ──────────────────────────────────────────────────────────────
o.cursorline = true
o.number = true
o.relativenumber = true
o.signcolumn = "yes" -- évite le décalage du texte quand un signe apparaît
o.ruler = true       -- la statusline par défaut n'affiche la position que si ruler est actif
o.scrolloff = 8
o.sidescrolloff = 8
o.winborder = "single"
o.pumborder = "single" -- 0.12 : le menu de complétion suit le style des flottantes
o.pummaxwidth = 60

-- La statusline par défaut affiche déjà les diagnostics, la progression LSP,
-- l'indicateur 'busy' et le code de sortie du terminal. Elle omet le type de
-- fichier, seule chose que lualine apportait ici : on l'insère au point de
-- bascule gauche/droite plutôt que de réécrire toute l'expression.
local statusline = vim.o.statusline
if statusline:find("%%=") then
  vim.o.statusline = (statusline:gsub("%%=", "%%=%%{&filetype} ", 1))
end

-- ── Indentation ────────────────────────────────────────────────────────────
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.wrap = false

-- ── Recherche ──────────────────────────────────────────────────────────────
o.ignorecase = true
o.smartcase = true

-- ── Complétion ─────────────────────────────────────────────────────────────
-- Native depuis 0.12 : plus besoin de vim.lsp.completion.enable(autotrigger)
-- sur LspAttach. Les sources viennent de 'complete', dans l'ordre, avec un
-- budget de temps dégressif ; `o` délègue à 'omnifunc', que le LSP pose lui-même.
-- Le `^N` plafonne le nombre de candidats par source.
o.autocomplete = true
o.autocompletedelay = 60 -- laisse passer une frappe rapide sans ouvrir le menu
o.complete = ".^10,o^10,w^5,b^5,kspell"
o.completeopt = "menuone,noinsert,popup,fuzzy"

-- ── Fichiers ───────────────────────────────────────────────────────────────
o.swapfile = false
o.backup = false
o.undofile = true
