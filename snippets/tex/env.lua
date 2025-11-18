local conds = require("utils.Luasnip.conditions")
local funcs = require("utils.Luasnip.helper_funcs")
local data = require("snippets.tex.data")
local line_begin = conds.line_begin

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
local rep = require("luasnip.extras").rep

local env = {
    as(
        { trig = "mm", name = "inline math" },
        fmta("$<>$", d(1, funcs.get_visual))
    ),

    as(
        { trig = "dm", name = "display math" },
        fmta(
            [[
                \[
                    <>
                \]
            ]],
            { d(0, funcs.get_visual) }
        ),
        { condition = line_begin }
    ),

    as(
        { trig = "aln", name = "align" },
        fmta(
            [[
                \begin{align<>}
                    <>
                \end{align<>}
            ]],
            {
                c(1, { t"*", t"" }),
                i(0),
                rep(1),
            }
        ),
        { condition = line_begin }
    ),

    as(
        { trig = "eqn", name = "equation" },
        fmta(
            [[
                \begin{equation}
                    \label{eq <>}
                    <>
                \end{equation}
            ]],
            { i(1), i(0), }
        ),
        { condition = line_begin }
    ),

    as(
        { trig = "itm", name = "itemize" },
        fmta(
            [[
                \begin{itemize}<>
                    \item <>
                \end{itemize}
            ]],
            { c(1, { t"", sn(nil, { t"[", i(1, "label=\\bullet"), t"]" }) }), i(0), }
        ),
        { condition = line_begin }
    ),

    as(
        { trig = "enm", name = "enumerate" },
        fmta(
            [[
                \begin{enumerate}<>
                    \item <>
                \end{enumerate}
            ]],
            { c(1, { t"", sn(nil, { t"[", i(1, "label=\\alpha*."), t"]" }) }), i(0), }
        ),
        { condition = line_begin }
    ),

    as({ trig = "ii", name = "item", dscr = "create new item lists" },
        t([[\item]]),
        { condition = conds.inListAndLineBegin }),

    as({ trig = "sec", name = "section"},
        fmta([[\section{<>}]], { i(1) }),
        { condition = conds.line_begin }),

    as({ trig = "ssec", name = "section"},
        fmta([[\subsection{<>}]], { i(1) }),
        { condition = conds.line_begin }),

    as({ trig = "sssec", name = "subsubsection"},
        fmta([[\subsubsection{<>}]], { i(1) }),
        { condition = conds.line_begin }),

    as({ trig = "chp", name = "chapter"},
        fmta([[\chapter{<>}]], { i(1) }),
        { condition = conds.line_begin }),

    as({ trig = "tcd", name = "tikzcd", dscr = "tikz commutative diagram" },
    fmta([[
    \begin{tikzcd}<>
        <>
    \end{tikzcd}
    ]],
    {
        c(1, {
            t"",
            sn(nil, { t"[", i(1), t"]" })
        }),
        i(0)
    }),
    { condition = line_begin }),

    as(
        { trig = "evt", name = "begin .. end" },
        fmta(
            [[
                \begin{<>}<>
                    <>
                \end{<>}
            ]],
            { i(1), c(2, { t"", sn(nil, { t"[", i(1), t"]" }) }), i(0), rep(1), }
        ),
        { condition = line_begin }
    ),

    as(
        { trig = "lb", name = "label" },
        fmta("\\label{<>}", { i(1) })
    ),

    as(
        { trig = "([acenp])rf", name = "reference", regTrig = true },
        fmta("\\<>ref{<>}",
            {
                f(function (_, snip) return data.ref_table[snip.captures[1]] end),
                i(1)
            })
    ),

    as({ trig = "cit", name = "cite" },
        fmta("\\cite{<>}", i(1)),
        { condition = conds.out_math }
    ),
}

return env
