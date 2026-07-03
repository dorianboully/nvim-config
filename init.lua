-- Name of the files inside "./lua/plugins/" to not load
-- Other option is to use enable = false inside a spec
local exclude = {}

if vim.g.vscode then
  require("config.vscode")
  -- UI, completion and LSP are VSCode's job; keep only editing plugins
  -- (mini.splitjoin, nvim-surround, treesitter + textobjects, vimtex).
  exclude = {
    "claude", "colors", "copilot", "icons", "lean", "lualine",
    "luasnip", "nvim-autopairs", "snacks", "typst-preview", "which-key",
  }
else
  require("config.options")
  require("config.keymaps")
  require("config.commands")
  require("config.lsp")
  require("config.treesitter")
end

local packUtil = require("utils.pack")
packUtil.packAddSpecs(packUtil.getSpecs("plugins", exclude))
