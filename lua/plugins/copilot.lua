return {
  src = "https://github.com/github/copilot.vim",
  name = "copilot",

  config = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_enabled = false
  end,

  keys = {
    {
      "<C-y>",
      "copilot#Accept('\\<C-y>')",
      desc = "Accept copilot suggestion",
      mode = "i",
      noremap = true,
      replace_keycodes = false,
      expr = true,
      silent = true,
    },
    { "<C-z>",    "<Plug>(copilot-dismiss)",     desc = "Dismiss Copilot suggestion", mode = "i", remap = true, },
    { "<C-down>", "<Plug>(copilot-next)",        desc = "Next item",                  mode = "i", remap = true, },
    { "<C-up>",   "<Plug>(copilot-previous)",    desc = "Previous item",              mode = "i", remap = true, },
    { "<C-h>",    "<Plug>(copilot-suggest)",     desc = "Copilot Suggest (h : hint)", mode = "i", remap = true, },
    { "<C-l>",    "<Plug>(copilot-accept-word)", desc = "Accept word",                mode = "i", remap = true, },
    { "<C-S-l>",  "<Plug>(copilot-accept-line)", desc = "Accept line",                mode = "i", remap = true, },
  }
}
