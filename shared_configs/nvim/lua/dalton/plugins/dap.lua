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

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to Cursor" })

      -- Eval var under cursor
      vim.keymap.set("n", "<leader>de", function()
        require("dapui").eval(nil, { enter = true })
      end, { desc = "Eval under cursor" })

      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<F6>", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<F7>", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<F8>", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<F9>", dap.step_back, { desc = "Step Back" })
      vim.keymap.set("n", "<F10>", dap.restart, { desc = "Restart" })
      vim.keymap.set("n", "<F11>", dap.stop, { desc = "Stop" })

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
      --
      -- Node.js/Playwright debugging
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { os.getenv("HOME") .. "/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
        }
      }

      dap.configurations.javascript = {
        {
          name = "Launch",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          name = "Playwright Debug",
          type = "pwa-node",
          request = "launch",
          program = "${workspaceFolder}/node_modules/@playwright/test/cli.js",
          args = { "test", "--debug", "${relativeFile}" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          env = {
            PWDEBUG = "1",
          },
        },
        {
          name = "Playwright Debug (Headed)",
          type = "pwa-node",
          request = "launch",
          program = "${workspaceFolder}/node_modules/@playwright/test/cli.js",
          args = { "test", "--debug", "--headed", "${relativeFile}" },
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          env = {
            PWDEBUG = "1",
          },
        },
        {
          name = "Playwright Debug (Current Test)",
          type = "pwa-node",
          request = "launch",
          program = "${workspaceFolder}/node_modules/@playwright/test/cli.js",
          args = function()
            local line = vim.fn.line(".")
            return { "test", "--debug", "${relativeFile}:" .. line }
          end,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          env = {
            PWDEBUG = "1",
          },
        },
      }

      dap.configurations.typescript = dap.configurations.javascript
    end,
  },
}
