vim.api.nvim_create_user_command("PackClean", require("utils.pack").packClean, {})
vim.api.nvim_create_user_command("PackListInactive", function()
  vim.print(require("utils.pack").getInactivePackages())
end, {})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*rc",
  callback = function()
    if vim.bo.filetype == "" then
      vim.bo.filetype = "sh"
    end
  end,
})

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "typst",
  callback = function()
    vim.bo.textwidth = 65
  end
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

vim.api.nvim_create_user_command(
  "TypstInit",
  function() coroutine.resume(
    coroutine.create(require("utils.typst").typstInit)
  ) end,
  {}
)

vim.api.nvim_create_user_command(
  "TypstDiagram",
    vim.schedule_wrap(function()
      vim.ui.open("https://q.uiver.app/")
    end),
    {}
)
