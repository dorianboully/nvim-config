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
}
