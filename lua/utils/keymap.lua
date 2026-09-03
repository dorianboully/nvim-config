local M = {}

---Envoie des touches sans les remapper.
---`i` insère en tête du buffer de frappe : sans lui, les touches sont mises en
---file derrière le mapping et avalées. `n` empêche le remap — indispensable,
---sinon une touche qui se rejoue elle-même boucle indéfiniment.
---@param keys string
M.feed = function(keys)
  vim.api.nvim_feedkeys(vim.keycode(keys), "in", false)
end

---Applique une table de raccourcis, éventuellement locale à un buffer.
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
      replace_keycodes = key.replace_keycodes,
    })
  end
end

return M
