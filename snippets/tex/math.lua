local conds = require("utils.Luasnip.conditions")
local funcs = require("utils.Luasnip.helper_funcs")
local data = require("snippets.tex.data")

local ls = require("luasnip")
local s = ls.snippet
local as = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local fmta = require("luasnip.extras.fmt").fmta

local math = {
    as(
    { trig = "lr([abcmnp])", name = "delimiters", regTrig = true },
    fmta("\\left<> <> \\right<>",
    {
        f(function(_, snip) return data.delim_table[snip.captures[1]][1] end),
        i(1),
        f(function(_, snip) return data.delim_table[snip.captures[1]][2] end),
    }
    ),
    { condition = conds.in_math }
    ),

    as(
    { trig = "ov([bBhHvVtT])", name = "over symbols", regTrig = true },
    fmta("\\<>{<>}",
    {
        f(function(_, snip) return data.over_symbols_table[snip.captures[1]] end),
        i(1),
    }),
    { condition = conds.in_math }),

    as({ trig='//', name='fraction', dscr="fraction (general)"},
    fmta([[
    \frac{<>}{<>}<>
    ]],
    { i(1), i(2), i(0) }),
    { condition = conds.in_math }),

    as({ trig="((\\d+)|(\\d*)(\\\\)?([A-Za-z]+)((\\^|_)(\\{\\d+\\}|\\d))*)\\//", name='fraction', dscr='auto fraction 1', trigEngine="ecma"},
    fmta([[
    \frac{<>}{<>}
    ]],
    { f(function (_, snip)
        return snip.captures[1]
    end), i(1) }),
    { condition = conds.in_math }),

    as({ trig='(^.*\\))//', name='fraction', dscr='auto fraction 2', trigEngine="ecma" },
    { d(1, funcs.generate_fraction) },
    { condition=conds.in_math }),

    as(
    { trig = "inv", name = "inverse", wordTrig = false },
    { t("^{-1}") },
    { condition = conds.in_math }
    ),

    as( { trig = "trp", name = "transpose", wordTrig = false },
    { t("^{\\top}") },
    { condition = conds.in_math }
    ),

    as(
        { trig = "m([cbrkfistCd])", name = "math fonts", regTrig = true },
        fmta("\\math<>{<>}",
            {
                f(function(_, snip) return data.math_font_table[snip.captures[1]] end),
                i(1),
            }
        ),
        { condition = conds.in_math }
    ),

    as( { trig = "([A-Z])%1", name = "mathbb shortcut", regTrig = true },
        fmta("\\mathbb{<>}", f(function (_, snip) return snip.captures[1] end)),
        { condition = conds.in_math }
    ),

    as({ trig = "sp", name = "superscript", wordTrig = false },
        fmta("^{<>}", i(1)),
        { condition = conds.in_math }
    ),

    as({ trig = "sb", name = "subscript", wordTrig = false },
        fmta("_{<>}", i(1)),
        { condition = conds.in_math }
    ),

    as(
        { trig = "sum", name = "sum" },
        fmta("\\sum<><>",
        {
            c(1, {
                fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty")}),
                fmta([[_{<>}]], { i(1, "i = 0") }),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }),

    as(
        { trig = "prd", name = "product" },
        fmta("\\prod<><>",
        {
            c(1, {
                fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty")}),
                fmta([[_{<>}]], { i(1, "i = 0") }),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }),

    as(
        { trig = "cpr", name = "coproduct" },
        fmta("\\coprod<><>",
        {
            c(1, {
                fmta([[_{<>}]], { i(1, "i \\in I") }),
                fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty")}),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }),

    as(
        { trig = "dsm", name = "direct sum" },
        fmta("\\bigoplus<><>",
        {
            c(1, {
                fmta([[_{<>}]], { i(1, "i \\in I") }),
                fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty")}),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }
    ),

    as(
        { trig = "Nn", name = "Big intersection" },
        fmta("\\bigcap<><>",
        {
            c(1, {
                fmta([[_{<>}]], { i(1, "i \\in I") }),
                fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty")}),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }
    ),

    as(
        { trig = "Uu", name = "Big union" },
        fmta("\\bigcup<><>",
        {
            c(1, {
                fmta([[_{<>}]], { i(1, "i \\in I") }),
                fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty")}),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }
    ),

    as(
        { trig = "dUu", name = "Big disjoint union" },
        fmta("\\bigsqcup<><>",
        {
            c(1, {
                fmta([[_{<>}]], { i(1, "i \\in I") }),
                fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty")}),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }
    ),

    as(
        { trig = "Ww", name = "Big wedge" },
        fmta("\\bigwedge<><>",
        {
            c(1, {
                fmta([[_{<>}]], { i(1, "i \\in I") }),
                fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty")}),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }
    ),

    as(
        { trig = "Vv", name = "Big vee" },
        fmta("\\bigvee<><>",
        {
            c(1, {
                fmta([[_{<>}]], { i(1, "i \\in I") }),
                fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty")}),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }
    ),

    as({ trig = "bnc", name = "binomial", dscr = "binomial (nCR)" },
    fmta([[ \binom{<>}{<>} ]],
    { i(1), i(2), }),
    { condition = conds.in_math, show_condition = conds.in_math }),

    as({ trig = "--", name = "tcd arrow", },
    fmta("\\ar[<><><><>]",
    {
        c(1, {
            fmta("<>,", { i(nil, "target : string of {r,l,u,d}") }) , t"", t"r,", t"d,", t"l,", t"u,"
        }),
        c(2, {
            fmta("<>,",{i(nil, "label : \"\\phi\"(') ")}), t""
        }),
        c(3, {
            fmta("<>,",{i(nil, "appearance : hook(')")}), t"", t"hook,", t"tail,", t"two heads,", t"dotted,", t"dashed,", t"harpoon,"
        }),
        c(4, {
            i(nil, "bend (last node) : bend left=20"), t"", t"bend left", t"bend right"
        })
    }),
    { condition = conds.in_tikzcd }),

    as(
        { trig = "int", name = "integral" },
        fmta("\\int<><>",
        {
            c(1, {
                fmta([[_{<>}^{<>}]], { i(1, "-\\infty"), i(2, "+\\infty")}),
                fmta([[_{<>}]], { i(1, "\\mathbb{R}") }),
                t("")}),
            i(0) } ),
        { condition = conds.in_math }),


    as(
        { trig = "pd", name = "partial derivative" },
        fmta("\\partial_{<>}", { i(1) }),
        { condition = conds.in_math }
    ),

    -- as(
    --     { trig = "([lrmh])a", name = "arrows", regTrig = true },
    --     fmta("\\<> <>", {
    --         f(function (_, snip) return data.arrows_table[snip.captures[1]] end),
    --         i(0)
    --     }),
    --     { condition = conds.in_math }
    -- ),

    as(
        { trig = "set", name = "set" },
        fmta(
            [[
                \left\{ <> ~<>~ <> \right\}
            ]],
            {
                i(1),
                c(2, { t";", t"\\middle|", sn(nil, i(1)) }),
                i(3),
            }),
        { condition = conds.in_math }
    ),

    as(
        { trig = "fn", name = "function" },
        c(1, {
            fmta(
                [[
                    \[
                        <> : <> \longrightarrow <> ~;~ <> \longmapsto <>
                    \]
                ]],
                { i(1, "f"), i(2, "X"), i(3, "Y"), i(4, "x"), i(5, "f(x)"), }
            ),
            fmta(
                [[
                    \begin{eqnarray}{RrCl}
                        <> : & <> & \longrightarrow & <>\\
                             & <> & \longmapsto     & <>\\
                    \end{eqnarray}
                ]],
                { i(1, "f"), i(2, "X"), i(3, "Y"), i(4, "x"), i(5, "f(x)"), }
            ),
        }),
        { condition = conds.out_math }
    ),
}

return math
