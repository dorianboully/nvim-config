-- Configurations of LSP servers are stored in vim.fn.stdpath("config") .. "/lsp/"
-- Here, we enable configurations according to the filenames (lua.lua, latex.lua, etc.)
vim.lsp.enable({ "lua", "tinymist", "jsonls" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my_lsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})
