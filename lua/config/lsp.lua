-- Les configurations de serveurs vivent dans lsp/, un fichier par serveur.
-- vim.lsp.enable() les active par nom de fichier.
vim.lsp.enable({ "lua", "tinymist", "jsonls", "basedpyright" })

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
