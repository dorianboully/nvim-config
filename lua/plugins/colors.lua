local name = "rose-pine"

return {
  src = "https://github.com/rose-pine/neovim",
  name = name,
  config = function()
    vim.cmd.colorscheme(name)
  end,
}
