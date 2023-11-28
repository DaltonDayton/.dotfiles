return {
    'mfussenegger/nvim-dap',
    config = function()
        vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>")
        -- vim.keymap.set("n", "<leader>dr", "<cmd>DapContinue<CR>")
        vim.keymap.set("n", "<F5>", "<cmd>lua require('dap').continue()<CR>")
        vim.keymap.set("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>")
        vim.keymap.set("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>")
        vim.keymap.set("n", "<F9>", "<cmd>lua require('dap').step_out()<CR>")
        vim.keymap.set("n", "<F1>", "<cmd>lua require('dapui').toggle()<CR>")
        vim.keymap.set("n", "<F6>", "<cmd>lua require('dap').down()<CR>")
        vim.keymap.set("n", "<F7>", "<cmd>lua require('dap').up()<CR>")
        vim.keymap.set("n", "<F8>", "<cmd>lua require('dap').run_to_cursor()<CR>")
        vim.keymap.set("n", "<F12>", "<cmd>lua require('dap').terminate()<CR>")
    end
}

