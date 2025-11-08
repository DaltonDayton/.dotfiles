vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- increment/decrement numbers use vim defaults: <C-a> and <C-x>

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffer navigation
vim.keymap.set("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })

-- Buffer management
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bs", ":b#<CR>", { desc = "Switch to last buffer" })

-- Window management
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make windows equal size" })
vim.keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current window" })
vim.keymap.set("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close other windows" })

-- Tab management
vim.keymap.set("n", "<leader>tN", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open buffer in new tab" })

-- Quickfix navigation
vim.keymap.set("n", "]q", ":cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", "[q", ":cprevious<CR>", { desc = "Previous quickfix" })

-- Quickfix management
vim.keymap.set("n", "<leader>qn", ":cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", "<leader>qp", ":cprevious<CR>", { desc = "Previous quickfix" })
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Close quickfix" })

-- Better window resizing
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize -2<CR>", { desc = "Increase window width" })

-- Core
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result, centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result, centered" })
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over selection without yanking" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
vim.keymap.set("n", "<leader>D", '"_d', { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>D", '"_d', { desc = "Delete selection without yanking" })
