-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', { desc = 'Move focus to the upper window' })

-- Personal Keymaps
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = '' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join line below' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Page down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Page up and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result, centered' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result, centered' })
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste over selection without yanking' })
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank selection to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
vim.keymap.set('n', '<leader>d', '"_d', { desc = 'Delete without yanking' })
vim.keymap.set('v', '<leader>d', '"_d', { desc = 'Delete selection without yanking' })
