local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return {
  s({ trig = "sp", name = "superscript", wordTrig = false },
    fmta("^(<>)", i(1)),
    {}
  ),

  s({ trig = "sb", name = "subscript", wordTrig = false },
    fmta("_(<>)", i(1)),
    {}
  ),

  s({ trig = "sbp", name = "subscript and superscript", wordTrig = false },
    fmta("_(<>)^(<>) <>", { i(1), i(2), i(0) }),
    {}
  ),
  s({ trig = "ttl", name = "env title", wordTrig = false },
    fmta('(title: "<>")', i(1)),
    {}
  )
}
