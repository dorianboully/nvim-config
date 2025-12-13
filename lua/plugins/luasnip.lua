return {
  src = "https://github.com/L3MON4D3/LuaSnip",

  name = "luasnip",

  opts = {
    enable_autosnippets = true,
    history = true,
    region_check_events = { "CursorMoved", "InsertEnter" },
    delete_check_events = { "TextChanged" },
    update_events = { "TextChanged", "TextChangedI" }
  },

  keys = {
    {
      "<C-j>",
      function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      mode = { "i", "s" },
      silent = true
    },
    {
      "<C-k>",
      function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end,
      mode = { "i", "s" },
      silent = true
    },
    {
      "<Tab>",
      function()
        local ls = require("luasnip")
        if ls.expandable() then
          vim.schedule(ls.expand)
          return
        elseif ls.jumpable(1) then
          vim.schedule(function() ls.jump(1) end)
        else
          return "<Tab>"
        end
      end,
      expr = true,
      mode = { "i", "s" },
      noremap = true
    },
    {
      "<S-Tab>",
      function()
        local ls = require("luasnip")
        if ls.expandable() then
          vim.schedule(ls.expand)
          return
        elseif ls.jumpable(-1) then
          vim.schedule(function() ls.jump(-1) end)
        else
          return "<S-Tab>"
        end
      end,
      expr = true,
      mode = { "i", "s" },
      noremap = true
    },
  },

  config = function(opts)
    require("luasnip").config.setup(opts)

    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" }
    })

    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" }
    })
  end
}
