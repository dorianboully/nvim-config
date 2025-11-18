local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local as = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local fmta = require("luasnip.extras.fmt").fmta

local M = {}

M.get_visual = function(_, parent)
    local selection = parent.snippet.env.SELECT_RAW
	if #selection > 0 then
		return sn(nil, i(1, selection))
    end

    return sn(nil, i(1))
end

M.symbol_snippet = function(context, command, opts)
	opts = opts or {}
	if not context.trig then
		error("context doesn't include a `trig` key which is mandatory", 2)
	end
	context.dscr = context.dscr or command
	context.name = context.name or command:gsub([[\]], "")
	context.docstring = context.docstring or (command .. [[{0}]])
	context.wordTrig = context.wordTrig or true
    -- local j, _ = string.find(command, context.trig)
    -- if j == 2 then -- command always starts with backslash
    --     context.trigEngine = "ecma"
    --     context.trig = "(?<!\\\\)" .. "(" .. context.trig .. ")"
    -- end
	return as(context, t(command), opts)
end

M.generate_fraction = function (_, snip)
    local stripped = snip.captures[1]
    local depth = 0
    local j = #stripped
    while true do
        local c = stripped:sub(j, j)
        if c == "(" then
            depth = depth + 1
        elseif c == ")" then
            depth = depth - 1
        end
        if depth == 0 then
            break
        end
        j = j - 1
    end
    return sn(nil,
        fmta([[
        <>\frac{<>}{<>}
        ]],
        { t(stripped:sub(1, j-1)), t(stripped:sub(j)), i(1)}))
end

return M
