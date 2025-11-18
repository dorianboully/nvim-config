return {
  src = "https://github.com/windwp/nvim-autopairs",

  name = "nvim-autopairs",

  opts = {
    extraRules = {
      lua = { { "<", ">" } },
      typst = { { "<", ">" }, { "$", "$" } },
      tex = { { "$", "$" } },
    },
  },

  config = function(opts)
    local Rule = require('nvim-autopairs.rule')
    local autopairs = require("nvim-autopairs")

    autopairs.setup()

    vim.iter(pairs(opts.extraRules)):each(
      function(fileType, rules)
        vim.iter(rules):each(function(rule)
          autopairs.add_rule(Rule(rule[1], rule[2], fileType))
        end)
      end
    )
  end
}
