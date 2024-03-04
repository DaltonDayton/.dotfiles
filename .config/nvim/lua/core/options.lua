-- Line number settings
vim.opt.nu = true               -- Enable line numbers
vim.opt.relativenumber = true   -- Enable relative line numbers

-- Indentation settings
vim.opt.tabstop = 8             -- Set the number of space characters inserted for a tab
vim.opt.softtabstop = 0         -- Set the number of spaces a <Tab> counts for while performing editing operations, like inserting a tab or using <BS>
vim.opt.shiftwidth = 4          -- Set the number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true        -- Convert tabs to spaces
vim.opt.smartindent = true      -- Enable smart indentation

-- Disable text wrapping
vim.opt.wrap = false

-- Backup and undo settings
vim.opt.swapfile = false        -- Disable swap file creation
vim.opt.backup = false          -- Disable backup file creation
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"  -- Set the directory for undo files
vim.opt.undofile = true         -- Enable persistent undo

-- Search settings
vim.opt.hlsearch = false        -- Disable search result highlighting
vim.opt.incsearch = true        -- Enable incremental search

-- Color settings
vim.opt.termguicolors = true    -- Enable true color support

-- Scrolling settings
vim.opt.scrolloff = 8           -- Keep 8 lines above/below the cursor when scrolling
vim.opt.signcolumn = "yes"      -- Always show the sign column, avoiding text shifting

-- File name settings
vim.opt.isfname:append("@-@")   -- Adjust 'isfname' option to consider '@' as part of a file name

-- Performance settings
vim.opt.updatetime = 50         -- Faster completion (4000ms default)
vim.opt.timeoutlen = 100        -- Time in milliseconds to wait for a mapped sequence to complete

-- Editor display settings
vim.opt.colorcolumn = "80"      -- Highlight column 80 to encourage limiting line length
vim.opt.conceallevel = 1        -- Hide certain elements (like markdown links) in a minimal manner

