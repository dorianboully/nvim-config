-- Les configurations de serveurs vivent dans lsp/, un fichier par serveur.
-- vim.lsp.enable() les active par nom de fichier.
vim.lsp.enable({ "lua", "tinymist", "jsonls", "basedpyright", "copilot" })

-- Repli : treesitter par défaut, LSP quand le serveur sait le faire.
-- foldlevelstart à 99 pour que les fichiers s'ouvrent dépliés.
vim.o.foldmethod = "expr"
vim.o.foldexpr = vim.treesitter.foldexpr
vim.o.foldtext = vim.lsp.foldtext
vim.o.foldlevelstart = 99

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp.attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- C'est 'autocomplete' qui ouvre le menu, et 'complete' contient `o`, donc
    -- la source LSP passe par 'omnifunc'. Cet appel reste indispensable : c'est
    -- lui qui câble les effets de bord de l'acceptation par <C-y> — expansion
    -- des snippets et additionalTextEdits. Seul `autotrigger` est devenu inutile.
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf)
    end

    if client:supports_method("textDocument/foldingRange") then
      vim.wo[vim.api.nvim_get_current_win()][0].foldexpr = vim.lsp.foldexpr
    end
  end,
})

-- Volontairement non activés d'office : les inlay hints et les codelens sont
-- du bruit dans un document typst. Ils restent sous <leader>uh et grx.

-- ── Complétion inline (copilot) ─────────────────────────────────────────────
-- Les raccourcis sont posés sans condition : sans client attaché, get() et
-- select() ne font simplement rien, et <C-y> retombe sur le menu.

local feed = require("utils.keymap").feed

-- Les suggestions se rafraîchissent seules en mode insertion : pas d'équivalent
-- de <Plug>(copilot-suggest) à mapper.
vim.lsp.inline_completion.enable()

--- Accepte une partie seulement de la suggestion, en tronquant le texte avant
--- qu'il soit appliqué.
---@param pattern string motif Lua capturant le fragment à conserver
local function accept_partial(pattern)
  return function()
    vim.lsp.inline_completion.get({
      on_accept = function(item)
        local text = item.insert_text
        if type(text) ~= "string" then
          text = text.value
        end
        item.insert_text = text:match(pattern) or text
        return item
      end,
    })
  end
end

vim.keymap.set("i", "<C-y>", function()
  -- Le menu de complétion a la priorité : <C-y> y est la touche d'acceptation
  -- native, celle qui déclenche l'expansion des snippets LSP.
  if vim.fn.pumvisible() == 1 then
    feed("<C-y>")
  else
    vim.lsp.inline_completion.get()
  end
end, { desc = "Accepter : menu de complétion, sinon suggestion inline" })

vim.keymap.set("i", "<C-l>", accept_partial("^%s*%S+"), { desc = "Accepter un mot de la suggestion" })
vim.keymap.set("i", "<C-S-l>", accept_partial("^[^\n]*"), { desc = "Accepter une ligne de la suggestion" })

vim.keymap.set("i", "<C-down>", function()
  vim.lsp.inline_completion.select({ count = 1 })
end, { desc = "Suggestion suivante" })

vim.keymap.set("i", "<C-up>", function()
  vim.lsp.inline_completion.select({ count = -1 })
end, { desc = "Suggestion précédente" })

vim.keymap.set("n", "<leader>ui", function()
  vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled())
end, { desc = "Basculer la complétion inline" })
