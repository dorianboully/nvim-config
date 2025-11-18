return {
  src = "https://github.com/nvim-mini/mini.nvim",
  opts = {
    modes = { insert = true, command = true, terminal = true }
  },
  config = function()
    require("mini.splitjoin").setup()
  end
}
