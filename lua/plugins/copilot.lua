return {
  src = "https://github.com/github/copilot.vim",
  name = "copilot",

  config = function()
    vim.g.copilot_no_tab_map = true
  end,

  keys = {
    { "<C-y>", "copilot#Accept('\\<C-y>')", desc = "Accept copilot suggestion", mode = "i",  replace_keycodes = false, expr = true, silent = true, },
    { "<C-z>", "<Plug>(copilot-dismiss)", desc = "Dismiss Copilot suggestion", mode = "i" },
    { "<C-down>", "<Plug>(copilot-next)", desc = "Next item", mode = "i" },
    { "<C-up>", "<Plug>(copilot-previous)", desc = "Previous item", mode = "i" },
    { "<C-h>", "<Plug>(copilot-suggest)", desc = "Copilot Suggest (h : hint)", mode = "i" },
    { "<C-l>", "<Plug>(copilot-accept-word)", desc = "Accept word", mode = "i", noremap = true },
    { "<C-S-l>", "<Plug>(copilot-accept-line)", desc = "Accept line", mode = "i" },
  }
}
