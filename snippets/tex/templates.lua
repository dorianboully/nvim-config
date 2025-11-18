local conds = require("utils.Luasnip.conditions")

local ls = require("luasnip")
local as = ls.extend_decorator.apply(ls.snippet, { snippetType = "autosnippet" })
local fmta = require("luasnip.extras.fmt").fmta
local i = ls.insert_node

return {
  as({ trig = "prb", name = "preamble" },
  fmta([[
  \documentclass[11pt]{article}
  \usepackage[utf8]{inputenc}
  \usepackage[T1]{fontenc}
  \usepackage[main=french, english, provide=*]{babel}
  \usepackage[autostyle, french=guillemets]{csquotes}
  \usepackage[margin=1.5in]{geometry}

  \usepackage{amsmath}
  \usepackage{amssymb, mathrsfs, dsfont, mathtools}
  \usepackage{amsthm}
  \numberwithin{equation}{section}

  \usepackage[french]{cleveref}

  \newcommand\isomto{\stackrel{\sim}{\smash{\rightarrow}\rule{0pt}{0.4ex}}}
  \newcommand\lisomto{\stackrel{\sim}{\smash{\longrightarrow}\rule{0pt}{0.4ex}}}
  \newcommand\isomfrom{\stackrel{\sim}{\smash{\leftarrow}\rule{0pt}{0.4ex}}}
  \newcommand\lisomfrom{\stackrel{\sim}{\smash{\longleftarrow}\rule{0pt}{0.4ex}}}

  \let\Re\relax
  \let\Im\relax

  \DeclareMathOperator{\Re}{Re}
  \DeclareMathOperator{\Im}{Im}
  \DeclareMathOperator{\im}{im}
  \DeclareMathOperator{\Id}{Id}
  \DeclareMathOperator{\id}{id}
  \DeclareMathOperator{\Tr}{Tr}
  \DeclareMathOperator{\Vect}{Vect}
  \DeclareMathOperator{\Spec}{Spec}
  \DeclareMathOperator{\Proj}{Proj}
  \DeclareMathOperator{\rad}{rad}
  \DeclareMathOperator{\Hom}{Hom}
  \DeclareMathOperator{\internalHom}{\mathcal{H}om}

  \theoremstyle{plain}
  \newtheorem{theo}{Théorème}[subsection]
  \newtheorem{prop}{Proposition}[subsection]
  \newtheorem{lemm}{Lemme}[subsection]
  \newtheorem{coro}{Corollaire}[subsection]

  \theoremstyle{definition}
  \newtheorem{defi}{Définition}[subsection]

  \theoremstyle{remark}
  \newtheorem{exem}{Exemple}[subsection]
  \newtheorem{rema}{Remarque}[subsection]
  \newtheorem{exer}{Exercice}[subsection]

  <>
  ]],
  { i(0) }),
  { condition = conds.doc_begin }),
}
