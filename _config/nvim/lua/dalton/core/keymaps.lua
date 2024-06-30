vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
-- vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split [W]indow [V]ertically" }) -- split window vertically
-- vim.keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split [W]indow [H]orizontally" }) -- split window horizontally
-- vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make split [W]indows equal[=] size" }) -- make split windows equal width & height
-- vim.keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
-- vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
-- vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
-- vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
-- vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Buffer Delete" })


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
