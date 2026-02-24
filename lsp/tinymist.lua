---@type vim.lsp.Config
return {
  cmd = { 'tinymist' },

  filetypes = { 'typst' },

  root_markers = { 'typst.toml', '.git', 'main.typ' },

  settings = {
    projectResolution = "lockDatabase",
    exportPdf = 'onSave',
    outputPath = "$root/$dir/$name",
    formatterMode = 'typstyle',
    lint = { enabled = true },
    completion = { triggerOnSnippetPlaceholders = true, },
  },

  on_attach = function(_, bufnr)
    local typst = require("utils.typst")

    vim.api.nvim_create_user_command("TypstView", function() typst.view() end, {})
    vim.api.nvim_create_user_command("TypstPreview", function() typst.togglePreview() end, {})
    vim.api.nvim_create_user_command("TypstWatch", function() typst.watch() end, {})
    vim.api.nvim_create_user_command("TypstCompile", function() typst.compile() end, {})
    vim.api.nvim_create_user_command("TypstPin", function() typst.togglePin() end, {})

    vim.keymap.set("n", "<localleader>v", "<cmd>TypstView<cr>", { buffer = bufnr })
    vim.keymap.set("n", "<localleader>p", "<cmd>TypstPreview<cr>", { buffer = bufnr, desc = "Toggle live preview" })
    vim.keymap.set("n", "<localleader>w", "<cmd>TypstWatch<cr>", { buffer = bufnr })
    vim.keymap.set("n", "<localleader>c", "<cmd>TypstCompile<cr>", { buffer = bufnr })
    vim.keymap.set("n", "<localleader>m", "<cmd>TypstPin<cr>", { buffer = bufnr, desc = "Toggle pin main file" })
  end
}
