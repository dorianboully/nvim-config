---@type vim.lsp.Config
return {
  cmd = { 'tinymist' },

  filetypes = { 'typst' },

  root_markers = { 'project.json', 'typst.toml', '.git' },

  settings = {
    exportPdf = 'never',
    outputPath = "$root/$dir/$name",
    formatterMode = 'typstyle',
    lint = { enabled = true },
    completion = { triggerOnSnippetPlaceholders = true, },
  },

  on_attach = function(_, bufnr)
    local project = require("utils.typst").initProject(bufnr)

    vim.api.nvim_create_user_command("TypstView", function() project:view() end, {})
    vim.api.nvim_create_user_command("TypstWatch", function() project:compile("watch") end, {})
    vim.api.nvim_create_user_command("TypstCompile", function() project:compile("compile") end, {})


    vim.keymap.set("n", "<localleader>v", "<cmd>TypstView<cr>", { buffer = bufnr })
    vim.keymap.set("n", "<localleader>w", "<cmd>TypstWatch<cr>", { buffer = bufnr })
    vim.keymap.set("n", "<localleader>c", "<cmd>TypstCompile<cr>", { buffer = bufnr })
  end
}
