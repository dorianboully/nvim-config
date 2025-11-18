local data = {}

data.ref_table = {
  a = "auto",
  c = "c",
  e = "eq",
  n = "name",
  p = "page",
}

data.delim_table = {
  a = { "\\langle", "\\rangle" },
  b = { "[", "]" },
  c = { "\\{", "\\}" },
  m = { "|", "|" },
  n = { "\\|", "\\|" },
  p = { "(", ")" },
}

data.math_font_table = {
  c = "cal",
  b = "bb",
  r = "rm",
  k = "frak",
  f = "bf",
  i = "it",
  s = "sf",
  t = "tt",
  C = "scr",
  d = "ds",
}

data.arrows_table = {
  l = "longleftarrow",
  r = "longrightarrow",
  m = "longmapsto",
  h = "hookrightarrow",
}

data.over_symbols_table = {
  b = "bar",
  h = "hat",
  v = "vec",
  t = "tilde",
  B = "overline",
  H = "widehat",
  V = "overrightarrow",
  T = "widetilde",
}

data.symbol_specs = {
  -- binary relations :
  -- 0)
  ["inn"] = { context = { name = "∈" }, command = [[\in]] },
  ["nni"] = { context = { name = "reverse ∈" }, command = [[\ni]] },
  ["nin"] = { context = { name = "∉" }, command = [[\notin]] },
  -- 1) order
  ["neq"] = { context = { name = "!=" }, command = [[\neq]] },
  ["leq"] = { context = { name = "≤" }, command = [[\leqslant]] },
  ["geq"] = { context = { name = "≥" }, command = [[\geqslant]] },
  ["llq"] = { context = { name = "<<" }, command = [[\ll]] },
  ["ggq"] = { context = { name = ">>" }, command = [[\gg]] },
  ["cc"] = { context = { name = "⊆" }, command = [[\subseteq]] },
  ["cnq"] = { context = { name = "strict ⊆" }, command = [[\varsubsetneq]] },
  ["ncq"] = { context = { name = "not ⊆" }, command = [[\nsubseteq]] },
  ["pp"] = { context = { name = "⊇" }, command = [[\supseteq]] },
  ["pnq"] = { context = { name = "stric ⊇" }, command = [[\varsupsetneq]] },
  ["npq"] = { context = { name = "not ⊇" }, command = [[\nsupseteq]] },
  -- 2) equivalence
  ["sim"] = { context = { name = "~" }, command = [[\sim]] },
  ["apr"] = { context = { name = "≈" }, command = [[\approx]] },
  ["seq"] = { context = { name = "≃" }, command = [[\simeq]] },
  ["eqs"] = { context = { name = "⋍" }, command = [[\backsimeq]] },
  ["eqv"] = { context = { name = "≡" }, command = [[\equiv]] },
  ["seqv"] = { context = { name = "≅" }, command = [[\cong]] },
  -- 3) operators
  [".."] = { context = { name = "·" }, command = [[\cdot ]] },
  ["l."] = { context = { name = "..." }, command = [[\ldots]] },
  ["c."] = { context = { name = "···" }, command = [[\cdots]] },
  ["xx"] = { context = { name = "×" }, command = [[\times]] },
  ["++"] = { context = { name = "⊕" }, command = [[\oplus]] },
  ["**"] = { context = { name = "⊗" }, command = [[\otimes]] },
  ["sm"] = { context = { name = "⧵" }, command = [[\setminus]] },
  ["nnn"] = { context = { name = "∩" }, command = [[\cap]] },
  ["uu"] = { context = { name = "∪" }, command = [[\cup]] },
  ["ww"] = { context = { name = "∧" }, command = [[\wedge]] },
  ["vv"] = { context = { name = "∨" }, command = [[\vee]] },
  ["cup"] = { context = { name = "cup product" }, command = [[\smile]] },
  ["cap"] = { context = { name = "cap product" }, command = [[\frown]] },
  -- sets
  ["Oo"] = { context = { name = "∅" }, command = [[\varnothing]] },
  ["::"] = { context = { name = ":" }, command = [[\colon]] },
  [":="] = { context = { name = "≔" }, command = [[\coloneqq]] },
  -- implications and equivalences
  ["ipl"] = { context = { name = "⇒" }, command = [[\implies]] },
  ["ipb"] = { context = { name = "⇐" }, command = [[\impliedby]] },
  ["iff"] = { context = { name = "⟺" }, command = [[\iff]] },
  -- arrows
  ["->"] = { context = { name = "->" }, command = [[\rightarrow]] },
  ["-->"] = { context = { name = "-->" }, command = [[\longrightarrow]] },
  ["<-"] = { context = { name = "<-" }, command = [[\leftarrow]] },
  ["<--"] = { context = { name = "<--" }, command = [[\longleftarrow]] },
  ["rma"] = { context = { name = "↦" }, command = [[\mapsto]] },
  ["Rma"] = { context = { name = "long ↦" }, command = [[\longmapsto]] },
  ["lma"] = { context = { name = "reverse ↦" }, command = [[\mapsfrom]] },
  ["Lma"] = { context = { name = "long reverse ↦" }, command = [[\longmapsfrom]] },
  ["rha"] = { context = { name = "hook ->" }, command = [[\hookrightarrow]] },
  ["lha"] = { context = { name = "hook <-" }, command = [[\hookleftarrow]] },
  ["rsa"] = { context = { name = "sim ->" }, command = [[\isomto]] },
  ["Rsa"] = { context = { name = "sim long ->" }, command = [[\lisomto]] },
  ["lsa"] = { context = { name = "sim <-" }, command = [[\isomfrom]] },
  ["Lsa"] = { context = { name = "sim long <-" }, command = [[\lisomfrom]] },
  ["upa"] = { context = { name = "↑" }, command = [[\uparrow]] },
  ["dna"] = { context = { name = "↓" }, command = [[\downarrow]] },
  -- etc
  ["ooo"] = { context = { name = "∞" }, command = [[\infty]] },
  ["lll"] = { context = { name = "ℓ" }, command = [[\ell]] },
  ["dag"] = { context = { name = "†" }, command = [[\dagger]] },
  ["bml"] = { context = { name = "♭" }, command = [[\flat]] },
  ["bcr"] = { context = { name = "♮" }, command = [[\natural]] },
  ["dies"] = { context = { name = "♯" }, command = [[\sharp]] },
  ["##"] = { context = { name = "#" }, command = [[\#]] },
  ["pm"] = { context = { name = "±" }, command = [[\pm]] },
  ["mp"] = { context = { name = "∓" }, command = [[\mp]] },
  -- Operator
  ["hom"] = { context = { name = "Hom" }, command = [[\Hom]] },
  ["Hom"] = { context = { name = "internal Hom" }, command = [[\internalHom]] },
  ["Spc"] = { context = { name = "Hom" }, command = [[\Spec]] },
  ["Prj"] = { context = { name = "Hom" }, command = [[\Proj]] },
  -- Space
  ["qd"] = { context = { name = "quad" }, command = [[\quad]] },
  [",,"] = { context = { name = "\\; space" }, command = [[\;]] },
}

return data
