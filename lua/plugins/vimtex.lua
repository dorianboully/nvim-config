return {
  src = "https://github.com/lervag/vimtex",
  config = function()
    vim.g.vimtex_imaps_leader = ";"

    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-pdf",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-shell-escape",
      },
      aux_dir = "temp",
      out_dir = "build",
    }
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "tex", "plaintex" },
      callback = function(ev)
        local mapKeys = require("utils.keymap").mapKeys

        local buf = ev.buf

        mapKeys({
            { "<leader>le", "<plug>(vimtex-env-surround-line)",   mode = "n",          desc = "VimTeX env surround (line)", },
            { "<leader>le", "<plug>(vimtex-env-surround-visual)", mode = "x",          desc = "VimTeX env surround (visual)", },
            { "<leader>lE", "<plug>(vimtex-errors)",              mode = "n",          desc = "VimTeX errors", },
            { "ai",         "<plug>(vimtex-am)",                  mode = { "x", "o" }, desc = "VimTeX: around math", },
            { "ii",         "<plug>(vimtex-im)",                  mode = { "x", "o" }, desc = "VimTeX: inner math", },
            { "am",         "<plug>(vimtex-a$)",                  mode = { "x", "o" }, desc = "VimTeX: around $", },
            { "im",         "<plug>(vimtex-i$)",                  mode = { "x", "o" }, desc = "VimTeX: inner $", },
            { "tsm",        "<plug>(vimtex-env-toggle-math)",     mode = "n",          desc = "VimTeX toggle math env", },
          },
          buf)
      end,
    })
  end
}
