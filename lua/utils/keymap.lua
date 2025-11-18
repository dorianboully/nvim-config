local isLoaded = require("utils.pack").isLoaded

local M = {}

---@param i integer
---@return string
local getChar = function(i)
  local pos = vim.api.nvim_win_get_cursor(0) -- (row, col)
  local row, col = pos[1] - 1, pos[2] + i    -- 0-indexed for API
  return vim.api.nvim_buf_get_text(0, row, col, row, col + 1, {})[1]
end

---@param i? integer  -- offset from cursor (default = 0 for next char, -1 for prev char)
---@param type? '"open"' | '"close"'  -- which type of delim to test; if nil, test both
---@param delims table
---@return boolean
local isDelim = function(i, type, delims)
  i = i or 0

  local isOpenDelim = function(ch)
    return vim.iter(vim.tbl_keys(delims)):any(function(delim) return ch == delim end)
  end

  local isCloseDelim = function(ch)
    return vim.iter(vim.tbl_values(delims)):any(function(delim) return ch == delim end)
  end

  local ch = getChar(i)
  if not ch then return false end

  if type == "open" then
    return isOpenDelim(ch)
  elseif type == "close" then
    return isCloseDelim(ch)
  else
    return isOpenDelim(ch) or isCloseDelim(ch)
  end
end

--- Exec tabout action in direction
---@param dir integer
local tabout = function(dir)
  local tbo = require("tabout")
  if dir == 0 then
    tbo.tabout()
  else
    tbo.taboutBack()
  end
end

---Create mappings from table for specified buffer
---@param keys? table
---@param bufnr? integer
M.mapKeys = function(keys, bufnr)
  if not keys then return end

  for i = 1, #keys do
    local key = keys[i]
    vim.keymap.set(key.mode or "n", key[1], key[2], {
      buffer = bufnr,
      desc = key.desc,
      expr = key.expr,
      noremap = key.noremap,
      silent = key.silent,
      remap = key.remap,
      replace_keycodes = key.replace_keycodes
    })
  end
end

--- Execute the keymap linked to str
---@param str string
---@param mode? string
M.feedkey = function(str, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(str, true, false, true),
    mode or "n",
    false)
end

--- tab behavior : accept pum suggestion > accpet copilot suggestion > jump out of delimiters/snippets > tab
---@param direction 0 | -1
M.chooseTabBehavior = function(direction)
  local jumpDir = direction == 0 and 1 or -1
  local delimType = direction == 0 and "close" or "open"
  local taboutLoaded = isLoaded("tabout")
  local lsLoaded = isLoaded("luasnip")

  if vim.fn.pumvisible() ~= 0 and direction == 0 then
    M.feedkey("<C-y>")
  elseif taboutLoaded and isDelim(direction, delimType, require("tabout.config").tabouts) then
    tabout(direction)
    -- TODO : Fix bug with two parentheses inside snippet
  elseif vim.snippet.active({ direction = 1 }) then
    vim.snippet.jump(1)
  elseif lsLoaded and require("luasnip").jump(jumpDir) then
  else
    if taboutLoaded then
      tabout(direction)
    else
      M.feedkey("<Tab>", "i")
    end
  end
end

return M

