return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            current_line_blame = false,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    opts.desc = opts.desc or "" -- Ensure description is present
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { expr = true, desc = "Next hunk" })

                map('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { expr = true, desc = "Previous hunk" })

                -- Actions
                map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = "Stage hunk" })
                map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = "Reset hunk" })
                map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage buffer" })
                map('n', '<leader>ha', gs.stage_hunk, { desc = "Stage hunk" })
                map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset buffer" })
                map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
                map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Blame line" })
                map('n', '<leader>tB', gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
                map('n', '<leader>hd', gs.diffthis, { desc = "Diff this" })
                map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff this with base" })

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select hunk" })
            end
        }
    end
}

-- TODO: Old config below, fix this stuff or figure out if fugitive is better

-- return {
--   "lewis6991/gitsigns.nvim",
--   event = { "BufReadPre", "BufNewFile" },
--   opts = {
--     on_attach = function(bufnr)
--       local gs = package.loaded.gitsigns
--
--       local function map(mode, l, r, desc)
--         vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
--       end
--
--       -- Navigation
--       map("n", "]h", gs.next_hunk, "Next Hunk")
--       map("n", "[h", gs.prev_hunk, "Prev Hunk")
--
--       -- Actions
--       map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
--       map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
--       map("v", "<leader>hs", function()
--         gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
--       end, "Stage hunk")
--       map("v", "<leader>hr", function()
--         gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
--       end, "Reset hunk")
--
--       map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
--       map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
--
--       map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
--
--       map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
--
--       map("n", "<leader>hb", function()
--         gs.blame_line({ full = true })
--       end, "Blame line")
--       map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
--
--       map("n", "<leader>hd", gs.diffthis, "Diff this")
--       map("n", "<leader>hD", function()
--         gs.diffthis("~")
--       end, "Diff this ~")
--
--       -- Text object
--       map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
--     end,
--   },
-- }
