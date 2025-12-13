if vim.g.vscode then
  require("config.vscode")
else
  require("config.options")
  require("config.keymaps")
  require("config.commands")
  require("config.lsp")
  require("config.treesitter")
end

-- Name of the files inside "./lua/plugins/" to not load
-- Other option is to use enable = false inside a spec
local exclude = {}

local packUtil = require("utils.pack")
packUtil.packAddSpecs(packUtil.getSpecs("plugins", exclude))
