return {
  src = "https://github.com/coder/claudecode.nvim",

  name = "claudecode",

  dependencies = { "folke/snacks.nvim" },

  config = true,
  opts = {
    auto_start = false,
  },

  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
  },
}
