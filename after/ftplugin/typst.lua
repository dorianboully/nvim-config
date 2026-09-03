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

local normal_maps = {}
if not vim.g.vscode then
  local actions = require("typst.actions")
  for lhs, mapping in pairs({
    ["<localleader>c"] = { actions.compile, "Compiler le document" },
    ["<localleader>d"] = { function() vim.ui.open("https://q.uiver.app/") end, "Ouvrir l'éditeur de diagrammes" },
    ["<localleader>i"] = {
      function() coroutine.resume(coroutine.create(require("typst.templates").init)) end,
      "Créer un projet depuis un template",
    },
    ["<localleader>m"] = { actions.pin, "Épingler le document principal" },
    ["<localleader>p"] = { "<cmd>TypstPreviewToggle<cr>", "Basculer la prévisualisation" },
    ["<localleader>v"] = { actions.view, "Ouvrir le PDF" },
  }) do
    vim.keymap.set("n", lhs, mapping[1], { buffer = 0, desc = mapping[2] })
    normal_maps[#normal_maps + 1] = lhs
  end
end

local undo_maps = vim.iter(normal_maps):map(function(lhs)
  return "execute 'silent! nunmap <buffer> " .. lhs .. "'"
end):join(" | ")
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
  .. " | execute 'silent! xunmap <buffer> am' | execute 'silent! ounmap <buffer> am'"
  .. " | execute 'silent! xunmap <buffer> im' | execute 'silent! ounmap <buffer> im'"
  .. (#undo_maps > 0 and " | " .. undo_maps or "")
