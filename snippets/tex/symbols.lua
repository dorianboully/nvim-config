local funcs = require("utils.Luasnip.helper_funcs")
local conds = require("utils.Luasnip.conditions")
local data = require("snippets.tex.data")

local symbol_snippets = {}
for k, v in pairs(data.symbol_specs) do
	table.insert(
		symbol_snippets,
		funcs.symbol_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.command, { condition = conds.in_math })
	)
end

return symbol_snippets
