---Envoie des touches sans les remapper.
---`i` insère en tête du buffer de frappe : sans lui les touches sont mises en
---file derrière le mapping et avalées. `n` empêche le remap — indispensable,
---sinon <Tab> se rappelle lui-même indéfiniment.
---@param keys string
local function feed(keys)
  vim.api.nvim_feedkeys(vim.keycode(keys), "in", false)
end

-- Ordre décidé : LuaSnip d'abord, parce que les autosnippets sont le flux
-- principal ; le menu de complétion ensuite, maintenant qu'il est ouvert
-- beaucoup plus souvent avec 'autocomplete' ; le <Tab> littéral en dernier.
-- Mapping simple et non `expr` : dans un `expr` on ne peut pas modifier le
-- buffer, ce qui obligeait à passer expand() et jump() par vim.schedule().
local function tab()
  local ls = require("luasnip")
  if ls.expandable() then
    ls.expand()
  elseif ls.locally_jumpable(1) then
    ls.jump(1)
  elseif vim.fn.pumvisible() == 1 then
    feed("<C-n>")
  else
    feed("<Tab>")
  end
end

local function shift_tab()
  local ls = require("luasnip")
  if ls.locally_jumpable(-1) then
    ls.jump(-1)
  elseif vim.fn.pumvisible() == 1 then
    feed("<C-p>")
  else
    feed("<S-Tab>")
  end
end

---@param dir 1|-1
local function choice(dir)
  return function()
    local ls = require("luasnip")
    if ls.choice_active() then
      ls.change_choice(dir)
    end
  end
end

return {
  src = "https://github.com/L3MON4D3/LuaSnip",
  name = "luasnip",

  opts = {
    enable_autosnippets = true,
    history = true,
    region_check_events = { "CursorMoved", "InsertEnter" },
    delete_check_events = { "TextChanged" },
    update_events = { "TextChanged", "TextChangedI" },
  },

  keys = {
    { "<Tab>",   tab,          mode = { "i", "s" }, desc = "Étendre, sauter, ou parcourir le menu", silent = true },
    { "<S-Tab>", shift_tab,    mode = { "i", "s" }, desc = "Saut arrière, ou menu",                 silent = true },
    { "<C-j>",   choice(1),    mode = { "i", "s" }, desc = "Choix suivant",                         silent = true },
    { "<C-k>",   choice(-1),   mode = { "i", "s" }, desc = "Choix précédent",                       silent = true },
  },

  config = function(opts)
    require("luasnip").config.setup(opts)

    local snippets = vim.fs.joinpath(vim.fn.stdpath("config"), "snippets")
    require("luasnip.loaders.from_lua").lazy_load({ paths = { snippets } })
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippets } })
  end,
}
