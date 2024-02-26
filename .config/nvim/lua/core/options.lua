-- Line Numbers
vim.opt.nu = true
-- Relative Line Numbers
vim.opt.relativenumber = true

-- Indenting
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

-- no backups from vim, give undotree access to long running undos
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- No sticky highligting, but enable incremental search highlighting
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Good colors
vim.opt.termguicolors = true

-- Keeps so many lines on the screen when scrolling
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.timeoutlen = 100

vim.opt.colorcolumn = "80"
