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
