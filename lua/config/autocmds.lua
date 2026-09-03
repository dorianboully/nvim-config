-- Détection de type de fichier et automatismes du socle.

-- Les fichiers en `rc` sans extension sont du shell. Priorité négative : ce
-- motif n'est consulté qu'après tous les autres, donc .zshrc, .vimrc et
-- compagnie gardent leur détection propre.
vim.filetype.add({
  pattern = {
    [".*rc"] = { "sh", { priority = -100 } },
  },
})

-- Surbrillance du texte copié — et, depuis 0.13, du texte collé.
vim.api.nvim_create_autocmd({ "TextYankPost", "TextPutPost" }, {
  group = vim.api.nvim_create_augroup("socle.highlight", { clear = true }),
  callback = function()
    vim.hl.hl_op()
  end,
})
