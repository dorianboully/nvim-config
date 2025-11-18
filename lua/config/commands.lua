vim.api.nvim_create_user_command("PackClean", require("utils.pack").packClean, {})
vim.api.nvim_create_user_command("PackListInactive", function()
  vim.print(require("utils.pack").getInactivePackages())
end, {})

-- Detect rc filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*rc",
  callback = function()
    if vim.bo.filetype == "" then
      vim.bo.filetype = "sh"
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex", "typst" },
  callback = function(args)
    vim.bo[args.buf].textwidth = 80
    vim.opt_local.breakindent = true
  end
})
