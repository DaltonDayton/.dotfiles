-- Set markdown files to wrap text
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt.colorcolumn = ""
    end,
})

-- Refresh diagnostics on save for Ruby
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.rb",
    callback = function()
        -- Insert and remove a space to trigger reanalysis
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { " " })
        vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col + 1, { "" })
    end,
})

