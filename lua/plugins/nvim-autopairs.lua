return {
  src = "https://github.com/windwp/nvim-autopairs",

  name = "nvim-autopairs",

  opts = {
    check_ts = true,
  },

  config = function(opts)
    local Rule = require('nvim-autopairs.rule')
    local autopairs = require("nvim-autopairs")
    local cond = require("nvim-autopairs.conds")

    autopairs.setup(opts)

    autopairs.add_rule(
      Rule("$", "$", "typst")
      :with_pair(function(o)
        local _, count = o.line
            :gsub("%$", "")
        return count % 2 == 0
      end)
      :with_move(cond.done())
    )
  end
}

