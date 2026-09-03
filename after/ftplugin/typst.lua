-- Mise en forme des buffers typst. Remplace l'autocommande FileType :
-- l'ftplugin est rejoué à chaque buffer, et `vim.b.undo_ftplugin` permet
-- à Neovim de défaire proprement ces réglages si le filetype change.

vim.bo.textwidth = 80

local w = vim.wo[0][0]
w.linebreak = true
w.breakindent = true
w.breakindentopt = "shift:2"

-- Pas de reformatage automatique du paragraphe pendant la frappe.
vim.opt_local.formatoptions:remove("t")

vim.b.undo_ftplugin = "setlocal textwidth< linebreak< breakindent< breakindentopt< formatoptions<"

-- Objets de texte « math », définis par queries/typst/textobjects.scm.
-- Locaux au buffer parce que la requête n'existe que pour typst : en TeX,
-- c'est vimtex qui fournit am/im, et ailleurs la capture n'existe pas.
for lhs, capture in pairs({ am = "@math.outer", im = "@math.inner" }) do
  vim.keymap.set({ "x", "o" }, lhs, function()
    require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
  end, { buffer = 0, desc = "Sélection math (" .. capture:sub(2) .. ")" })
end

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | execute 'silent! xunmap <buffer> am' | execute 'silent! xunmap <buffer> im'"
