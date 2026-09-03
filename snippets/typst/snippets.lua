local ls = require("luasnip")

local function in_math()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local node = vim.treesitter.get_node({ pos = { row - 1, math.max(col - 1, 0) } })
  while node do
    if node:type() == "math" then return true end
    node = node:parent()
  end
  return false
end

local path = vim.fs.joinpath(vim.fn.stdpath("config"), "snippets", "typst", "data.json")
local data = vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))

return vim.tbl_map(function(item)
  -- A semicolon is an explicit opt-in under Neovim: unlike HyperSnips, the
  -- user confirms it with <Tab>. Other automatic snippets retain their mode.
  local automatic = item.automatic and not item.trigger:find(";", 1, true)
  local context = {
    trig = item.trigger,
    name = item.description,
    wordTrig = not item.inWord,
    snippetType = automatic and "autosnippet" or "snippet",
  }
  local opts = item.math and { condition = in_math, show_condition = in_math } or nil
  return ls.snippet(context, ls.parser.parse_snippet(nil, item.body), opts)
end, data)
