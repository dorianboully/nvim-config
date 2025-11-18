return {
  src = "https://github.com/nvim-mini/mini.nvim",
  opts = {
    modes = { insert = true, command = true, terminal = true }
  },
  config = function(opts)
    local pairs = require("mini.pairs")

    pairs.setup(opts)

    require("mini.splitjoin").setup()

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lua", },
      callback = function(ev)
        local buf = ev.buf
        pairs.map_buf(buf, "i", "<", { action = "open", pair = "<>" })
        pairs.map_buf(buf, "i", ">", { action = "close", pair = "<>" })
      end
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "tex", "plaintex", "typst" },
      callback = function(ev)
        local buf = ev.buf

        pairs.map_buf(buf, "i", "$", { action = "closeopen", pair = "$$", })
      end
    })
  end
}
