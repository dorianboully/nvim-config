local M = {}

M.line_begin = require("luasnip.extras.conditions.expand").line_begin

function M.first_line()
    local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
    return r == 1
end

function M.doc_begin(line_to_cursor, matched_trigger, captures)
    return M.line_begin(line_to_cursor, matched_trigger, captures) and M.first_line()
end

function M.in_math()
    return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

function M.out_math()
    return not M.in_math()
end

function M.in_comment()
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end

function M.in_beamer()
	return vim.b.vimtex["documentclass"] == "beamer"
end

local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

function M.inListAndLineBegin(line_to_cursor, matched_trigger, captures)
            return M.line_begin(line_to_cursor, matched_trigger, captures) and (env("enumerate") or env("itemize") or env("description"))
        end

function M.in_preamble()
	return not env("document")
end

function M.in_text()
	return env("document") and not M.in_math()
end

function M.in_tikz()
	return env("tikzpicture")
end

function M.in_tikzcd()
	return env("tikzcd")
end
function M.in_bullets()
	return env("itemize") or env("enumerate")
end

function M.in_align()
	return env("align") or env("align*") or env("aligned")
end

return M
