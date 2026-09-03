-- Posé au niveau module, donc avant vim.pack.add : plugin/copilot.vim appelle
-- s:MapTab() dès le sourcing, et sans ce drapeau il s'empare de <Tab> avant que
-- LuaSnip ait pu le remapper.
vim.g.copilot_no_tab_map = true

return {
  src = "https://github.com/github/copilot.vim",
  name = "copilot",

  keys = {
    {
      "<C-y>",
      function()
        -- Le menu de complétion a la priorité : <C-y> y est la touche
        -- d'acceptation native, celle qui déclenche l'expansion des snippets
        -- LSP. Copilot ne récupère la touche que menu fermé.
        if vim.fn.pumvisible() == 1 then
          return vim.keycode("<C-y>")
        end
        return vim.fn["copilot#Accept"](vim.keycode("<C-y>"))
      end,
      mode = "i",
      desc = "Accepter : menu de complétion, sinon copilot",
      expr = true,
      replace_keycodes = false,
      silent = true,
    },
    { "<C-z>",     "<Plug>(copilot-dismiss)",      desc = "Rejeter la suggestion",  mode = "i" },
    { "<C-down>",  "<Plug>(copilot-next)",         desc = "Suggestion suivante",    mode = "i" },
    { "<C-up>",    "<Plug>(copilot-previous)",     desc = "Suggestion précédente",  mode = "i" },
    { "<C-h>",     "<Plug>(copilot-suggest)",      desc = "Demander une suggestion", mode = "i" },
    { "<C-l>",     "<Plug>(copilot-accept-word)",  desc = "Accepter un mot",        mode = "i", noremap = true },
    { "<C-S-l>",   "<Plug>(copilot-accept-line)",  desc = "Accepter une ligne",     mode = "i" },
  },
}
