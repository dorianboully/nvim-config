local ts = vim.treesitter

-- Reuse the LaTeX parser for TeX/PlainTeX buffers
vim.treesitter.language.register("latex", "tex")
vim.treesitter.language.register("latex", "plaintex")

local function set_textobject_queries()
  local function_queries = [[
    (function_definition) @function.outer
    (function_definition body: (_) @function.inner)

    (function_declaration) @function.outer
    (function_declaration body: (_) @function.inner)

    (function) @function.outer
    (function body: (_) @function.inner)

    (method_definition) @function.outer
    (method_definition body: (_) @function.inner)

    (function_item) @function.outer
    (function_item body: (_) @function.inner)
  ]]

  for _, lang in ipairs({ "lua", "python", "typescript", "javascript", "rust", "go" }) do
    ts.query.set(lang, "textobjects", function_queries)
  end

  ts.query.set(
    "typst",
    "textobjects",
    function_queries
      .. [[
    (math) @math.outer
    (math) @math.inner (#offset! @math.inner 0 1 0 -1)
  ]]
  )
end

local function set_textobject_keymaps()
  local mapKeys = require("utils.keymap").mapKeys

  local function selection(keys, query, desc)
    return {
      mode = { "o", "x" },
      keys,
      function() ts.select({ query = query, query_group = "textobjects", lookahead = true }) end,
      desc = desc,
      silent = true,
    }
  end

  local selections = {
    selection("af", "@function.outer", "Around function"),
    selection("if", "@function.inner", "Inner function"),
    selection("am", "@math.outer", "Around math"),
    selection("im", "@math.inner", "Inner math"),
  }

  mapKeys(selections)
end

set_textobject_queries()
set_textobject_keymaps()
