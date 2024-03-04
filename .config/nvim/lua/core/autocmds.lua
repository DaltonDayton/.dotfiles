-- Set markdown files to wrap text
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt.colorcolumn = ""
    end,
})
