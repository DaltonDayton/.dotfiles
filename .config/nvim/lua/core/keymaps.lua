vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open command-line window" })

-- Move highlighted text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Append line below to end of current line
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line below" })

-- Keeps cursor in the middle when moving
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })

-- Keeps search terms in the middle
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result, centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result, centered" })

-- Paste over highlighted text without losing original copy
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste over selection without yanking" })

-- Yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank line to system clipboard" })

-- Delete to void register
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete without yanking" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete selection without yanking" })

-- Ctrl-C is Escape
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Map Ctrl-C to Escape in insert mode" })

-- Q is a bad place?
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- Quick Fix Navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next item in quickfix list" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous item in quickfix list" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next item in location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous item in location list" })

-- Replace the current word throughout
vim.keymap.set("n", "<leader>sw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Replace word under cursor" })

-- Makes a file executable
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
