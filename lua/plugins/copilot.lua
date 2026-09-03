-- copilot.vim n'est plus utilisé comme plugin : on ne garde le dépôt que pour
-- le serveur qu'il embarque (@github/copilot-language-server), que Neovim
-- pilote lui-même via vim.lsp.inline_completion. Voir lsp/copilot.lua.
--
-- Deux verrous, tous deux nécessaires :
--
--   `load = false` empêche vim.pack de sourcer plugin/ au moment du add(),
--   mais met quand même le dossier sur le 'runtimepath' — et la phase
--   |load-plugins| du démarrage le source alors quand même.
--
--   g:loaded_copilot est la garde que plugin/copilot.vim teste en première
--   ligne. Posée ici au niveau module, donc avant vim.pack.add, elle le fait
--   sortir immédiatement. Sans elle, copilot#Init() démarrerait son propre
--   serveur et on en aurait deux.
vim.g.loaded_copilot = 1

return {
  src = "https://github.com/github/copilot.vim",
  name = "copilot",
  load = false,
}
