if vim.g.vscode then
  require("config.vscode")
  -- UI, completion, LSP and editing plugins are all VSCode's job; load none.
else
  require("config.options")
  require("config.keymaps")
  require("config.autocmds")
  require("config.commands")
  require("config.lsp")
  require("config.treesitter")

  local plugins = require("config.plugins")
  plugins.add(plugins.all())
end
