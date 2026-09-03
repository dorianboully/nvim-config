-- Socle : uniquement ce que Neovim ne fait pas déjà tout seul.
--
-- Volontairement absents, parce que ce sont des défauts depuis 0.11/0.12 :
--   LSP        grn gra grr gri grt grx gO K <C-s>
--   diagnostic ]d [d ]D [D <C-w>d
--   listes     ]q [q  ]l [l  ]b [b  ]t [t  ]a [a  ]<Space> [<Space>
--   commentaire gc gcc
--   explorateur -  (plugin natif `dir`, remonte d'un niveau)
--   fenêtres   <C-w>hjkl, et <C-l> (nohlsearch + diffupdate + multi-curseurs)

local map = vim.keymap.set

-- ── Registres ──────────────────────────────────────────────────────────────
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copier vers le presse-papier" })
map("n", "<leader>Y", '"+Y', { desc = "Copier la ligne vers le presse-papier" })
map({ "n", "v" }, "x", '"_x', { desc = "Supprimer un caractère sans copier" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Supprimer sans copier" })
-- En visuel, `P` préserve déjà le registre — seul `p` l'écrase. Un seul mapping suffit.
map("x", "p", '"_dP', { desc = "Coller sans écraser le registre" })

-- ── Insertion ──────────────────────────────────────────────────────────────
map("i", "<C-g>", "<C-k>", { desc = "Insérer un digraphe" }) -- <C-k> sert aux snippets
map("i", "<C-space>", "<C-x><C-o>", { desc = "Complétion omni manuelle" })

-- ── Recherche ──────────────────────────────────────────────────────────────
-- `n`/`N` gardent une direction fixe, et rouvrent le pli sur la cible.
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Résultat suivant" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Résultat précédent" })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Résultat suivant" })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Résultat précédent" })

-- La surbrillance s'efface au premier mouvement horizontal.
-- `expr` et non `<cmd>` : avec `<cmd>noh<cr>h`, la commande absorbait le
-- compteur et `3h` ne déplaçait que d'une colonne.
local function clear_hl(key)
  return function()
    vim.cmd.nohlsearch()
    return key
  end
end

for _, key in ipairs({ "h", "l", "gj", "gk" }) do
  map("n", key, clear_hl(key), { expr = true, desc = "Efface la surbrillance, puis " .. key })
end

map("n", "<esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Efface la surbrillance" })

-- ── Mouvement ──────────────────────────────────────────────────────────────
-- Sans compteur, suivre les lignes visuelles ; avec, les lignes réelles.
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Bas" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Haut" })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Bas" })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Haut" })

-- ── Fenêtres ───────────────────────────────────────────────────────────────
-- Pas d'alias <C-hjkl> : <C-w>hjkl est le natif, et surtout <C-l> a son propre
-- défaut en mode normal — une chaîne exécutée en entier à chaque appel :
--   nohlsearch | diffupdate | vider les multi-curseurs (|Q|) | redessiner
-- Chaque étape est sans effet s'il n'y a rien à faire, d'où l'impression d'un
-- repli en cascade. Le masquer coûtait le seul moyen d'effacer les curseurs.
-- Le mode terminal, lui, n'a aucun défaut : ses raccourcis restent plus bas.

map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Agrandir en hauteur" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Réduire en hauteur" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Réduire en largeur" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Agrandir en largeur" })

-- ── Déplacement de lignes ──────────────────────────────────────────────────
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Descendre la ligne" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Monter la ligne" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Descendre la ligne" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Monter la ligne" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Descendre la sélection" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Monter la sélection" })

-- ── Buffers ────────────────────────────────────────────────────────────────
-- Alias ergonomiques de ]b / [b, qui existent maintenant par défaut.
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer suivant" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer précédent" })
map("n", "<leader>bd", "<cmd>bprevious | bd #<cr>", { desc = "Fermer le buffer, garder la fenêtre" })
map("n", "<leader>bD", "<cmd>bd<cr>", { desc = "Fermer le buffer et la fenêtre" })

-- ── Explorateur (plugin natif `dir`) ───────────────────────────────────────
-- `-` remonte d'un niveau, c'est un mapping global par défaut.
map("n", "<leader>E", function()
  local dir = vim.fn.expand("%:h")
  vim.cmd.vsplit(dir ~= "" and dir or vim.fn.getcwd())
end, { desc = "Explorateur (split vertical)" })

-- ── LSP (cœur, pas un plugin) ──────────────────────────────────────────────
map("n", "<leader>bf", function() vim.lsp.buf.format() end, { desc = "Formater le buffer" })

-- ── Terminal ───────────────────────────────────────────────────────────────
map("t", "<C-g>", "<C-\\><C-n>", { desc = "Sortir du mode terminal" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Fenêtre de gauche" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Fenêtre du bas" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Fenêtre du haut" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Fenêtre de droite" })
