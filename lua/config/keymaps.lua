local map = vim.keymap.set

-- Yank/Paste to/from system clipboard.
map({ "n", "v" }, "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')
map("v", "p", '"_dp')
map("v", "P", '"_dP')
map("n", "<leader>e", "<cmd>Explore<CR>")
map("n", "<leader>E", "<cmd>Vexplore<CR>")

-- Format buffer
map("n", "<leader>bf", vim.lsp.buf.format, { desc = "Format current buffer" })

-- Typst
map("n", "<leader>td", "<cmd>TypstDiagram<cr>", { desc = "Open web diagram helper" })
map("n", "<leader>ti", "<cmd>TypstInit<cr>", { desc = "Init typst project"})

-- Don't yank when deleting text
map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "<leader>d", '"_d')

-- Clear hlsearch
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "clear hlsearch and escape" })
map("n", "h", "<cmd>noh<cr>h", { desc = "clear hlsearch and move left" })
map("n", "gj", "<cmd>noh<cr>gj", { desc = "clear hlsearch and move down" })
map("n", "gk", "<cmd>noh<cr>gk", { desc = "clear hlsearch and move up" })
map("n", "l", "<cmd>noh<cr>l", { desc = "clear hlsearch and move right" })
map("i", "jk", "<Esc>", { remap = true })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { remap = true, desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { remap = true, desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { remap = true, desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { remap = true, desc = "Up", expr = true, silent = true })


-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bd", "<cmd>bprevious | bd #<cr>", { desc = "Delete Buffer keep Window" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

map('i', '<c-space>', '<c-x><c-o>', { desc = "Trigger completion" })
