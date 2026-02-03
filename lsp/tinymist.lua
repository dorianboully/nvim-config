---@type vim.lsp.Config
return {
  cmd = { 'tinymist' },

  filetypes = { 'typst' },

  root_markers = { 'typst.toml', '.git', 'main.typ' },

  settings = {
    projectResolution = "lockDatabase",
    exportPdf = 'never',
    outputPath = "$root/$dir/$name",
    formatterMode = 'typstyle',
    lint = { enabled = true },
    completion = { triggerOnSnippetPlaceholders = true, },
  },

  on_attach = function(_, bufnr)
    local typst = require("utils.typst")

    vim.api.nvim_create_user_command("TypstView", function() typst.view() end, {})
    vim.api.nvim_create_user_command("TypstWatch", function() typst.compile("watch") end, {})
    vim.api.nvim_create_user_command("TypstCompile", function() typst.compile("compile") end, {})


    vim.keymap.set("n", "<localleader>v", "<cmd>TypstView<cr>", { buffer = bufnr })
    vim.keymap.set("n", "<localleader>w", "<cmd>TypstWatch<cr>", { buffer = bufnr })
    vim.keymap.set("n", "<localleader>c", "<cmd>TypstCompile<cr>", { buffer = bufnr })
  end
}
