return {
  src = "https://github.com/chomosuke/typst-preview.nvim",
  name = "typst-preview",
  keys = {
    { "<localleader>p", "<cmd>TypstPreviewToggle<cr>", mode = "n", desc = "Preview typst document" }
  },
  config = true,
  opts = {
    get_main_file = function(path_of_buffer)
      return require("utils.typst")._pinnedPath or path_of_buffer
    end,
  },
}
