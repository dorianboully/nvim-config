return {
  src = "https://github.com/folke/snacks.nvim",
  opts = {
    explorer = {},
    picker = {},
    toggle = {},
  },
  keys = {
    { "<leader>bo", function() Snacks.bufdelete.other() end,                                desc = "Delete other buffers", },
    -- Top Pickers & Explorer
    { "<leader>/",  function() Snacks.picker.grep() end,                                    desc = "Grep", },
    { "<leader>e",  function() Snacks.explorer() end,                                       desc = "File Explorer", },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end,                                 desc = "Buffers", },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File", },
    { "<leader>ff", function() Snacks.picker.files() end,                                   desc = "Find Files", },
    { "<leader>fr", function() Snacks.picker.recent() end,                                  desc = "Recent", },
    -- Grep
    { "<leader>sB", function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers", },
    { "<leader>sg", function() Snacks.picker.grep() end,                                    desc = "Grep", },
    { "<leader>sw", function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" }, },
    -- search
    { "<leader>sb", function() Snacks.picker.lines() end,                                   desc = "Buffer Lines", },
    { "<leader>sc", function() Snacks.picker.command_history() end,                         desc = "Command History", },
    { "<leader>sC", function() Snacks.picker.commands() end,                                desc = "Commands", },
    { "<leader>sd", function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics", },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics", },
    { "<leader>sh", function() Snacks.picker.help() end,                                    desc = "Help Pages", },
    { "<leader>sk", function() Snacks.picker.keymaps() end,                                 desc = "Keymaps", },
    { "<leader>sq", function() Snacks.picker.qflist() end,                                  desc = "Quickfix List", },
    { "<leader>sR", function() Snacks.picker.resume() end,                                  desc = "Resume", },
    { "<leader>su", function() Snacks.picker.undo() end,                                    desc = "Undo History", },
    { "<leader>uC", function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes", },
    -- LSP
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols", },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols", },
    { "<leader>cl", function() Snacks.picker.lsp_config() end,                              desc = "Lsp Info" },
  },

  config = function(opts)
    require("snacks").setup(opts)
    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    Snacks.toggle.diagnostics():map("<leader>ud")
    Snacks.toggle.treesitter():map("<leader>uT")
    Snacks.toggle.inlay_hints():map("<leader>uh")
    Snacks.toggle.indent():map("<leader>ug")
  end,
}
