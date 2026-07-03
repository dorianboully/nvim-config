if vim.g.vscode then
  require("config.vscode")
  -- UI, completion, LSP and editing plugins are all VSCode's job; load none.
else
  require("config.options")
  require("config.keymaps")
  require("config.commands")
  require("config.lsp")
  require("config.treesitter")

  local packUtil = require("utils.pack")
  packUtil.packAddSpecs(packUtil.getSpecs("plugins", {}))
end
