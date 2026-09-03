-- Commandes utilisateur. Le typst sera repris en phase 4.

vim.api.nvim_create_user_command("TypstInit", function()
  coroutine.resume(coroutine.create(require("utils.typst").typstInit))
end, { desc = "Créer un projet typst depuis un template local" })

vim.api.nvim_create_user_command("TypstDiagram", vim.schedule_wrap(function()
  vim.ui.open("https://q.uiver.app/")
end), { desc = "Ouvrir l'éditeur de diagrammes commutatifs" })
