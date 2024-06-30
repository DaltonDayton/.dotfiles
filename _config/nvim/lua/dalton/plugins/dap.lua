return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local ui = require("dapui")

            require("dapui").setup()
            require("nvim-dap-virtual-text").setup({})


            vim.fn.sign_define('DapBreakpoint',
                { text = '🔴', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })

            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to Cursor" })

            -- Eval var under cursor
            vim.keymap.set("n", "<leader>de", function()
                require("dapui").eval(nil, { enter = true })
            end, { desc = "Eval under cursor" })

            vim.keymap.set("n", "<F1>", dap.continue, { desc = "Continue" })
            vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Step Out" })
            vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Step Back" })
            vim.keymap.set("n", "<F6>", dap.restart, { desc = "Restart" })

            -- Toggle UI
            vim.keymap.set("n", "<leader>du", function()
                require("dapui").toggle()
            end, { desc = "Toggle UI" })

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    },
}
