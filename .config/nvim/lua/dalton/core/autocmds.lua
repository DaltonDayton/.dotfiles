-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Command to disable formatting
vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

-- Command to enable formatting
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

-- Command to toggle formatting
vim.api.nvim_create_user_command("FormatToggle", function()
    if vim.g.disable_autoformat or vim.b.disable_autoformat then
        -- If formatting is currently disabled, enable it
        vim.cmd("FormatEnable")
        print("Autoformatting is now enabled.")
    else
        -- If formatting is currently enabled, disable it
        vim.cmd("FormatDisable")
        print("Autoformatting is now disabled.")
    end
end, {
    desc = "Toggle autoformat-on-save using existing enable/disable commands",
})
