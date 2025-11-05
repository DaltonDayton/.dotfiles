return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "jay-babu/mason-nvim-dap.nvim", -- Ensure mason-nvim-dap loads first
  },
  config = function()
    local dap = require("dap")
    local ui = require("dapui")
    local virtual_text = require("nvim-dap-virtual-text")

    ui.setup()
    virtual_text.setup({})

    -- Manually register js-debug-adapter (pwa-node) since mason-nvim-dap doesn't do it automatically
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    -- Register aliases for compatibility
    dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]
    dap.adapters["node"] = dap.adapters["pwa-node"]

    -- Add Playwright test configurations
    dap.configurations.typescript = dap.configurations.typescript or {}
    dap.configurations.javascript = dap.configurations.javascript or {}

    table.insert(dap.configurations.typescript, {
      type = "pwa-node",
      request = "launch",
      name = "Debug Playwright Test (File)",
      runtimeExecutable = "npx",
      runtimeArgs = { "playwright", "test", "--headed", "--timeout", "0" },
      args = { "${file}" },
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    })

    table.insert(dap.configurations.javascript, {
      type = "pwa-node",
      request = "launch",
      name = "Debug Playwright Test (File)",
      runtimeExecutable = "npx",
      runtimeArgs = { "playwright", "test", "--headed", "--timeout", "0" },
      args = { "${file}" },
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    })

    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )

    -- Keybinds
    vim.keymap.set("n", "<F5>", function() require("dap").continue() end)
    vim.keymap.set("n", "<F7>", function() require("dap").step_over() end)
    vim.keymap.set("n", "<F8>", function() require("dap").step_into() end)
    vim.keymap.set("n", "<F9>", function() require("dap").step_out() end)
    vim.keymap.set("n", "<Leader>db", function() require("dap").toggle_breakpoint() end)
    vim.keymap.set("n", "<Leader>dL", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
    vim.keymap.set("n", "<Leader>dr", function() require("dap").repl.open() end)
    vim.keymap.set("n", "<Leader>dl", function() require("dap").run_last() end)
    vim.keymap.set({ "n", "v" }, "<Leader>dh", function() require("dap.ui.widgets").hover() end)
    vim.keymap.set({ "n", "v" }, "<Leader>dP", function() require("dap.ui.widgets").preview() end)
    vim.keymap.set("n", "<Leader>df", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set("n", "<Leader>ds", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end)

    -- Dap UI
    vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle UI" })
    dap.listeners.before.attach.dapui_config = function() ui.open() end
    dap.listeners.before.launch.dapui_config = function() ui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
    dap.listeners.before.event_exited.dapui_config = function() ui.close() end

    -- Playwright-specific DAP keybindings
    vim.keymap.set("n", "<leader>dpt", function()
      -- Find and run the Playwright configuration
      local ft = vim.bo.filetype
      if ft == "typescript" or ft == "javascript" then
        local configs = dap.configurations[ft]
        if configs then
          for _, config in ipairs(configs) do
            if config.name and config.name:match("Playwright") then
              dap.run(config)
              return
            end
          end
        end
      end
      vim.notify("No Playwright debug configuration found. Ensure you're in a .ts or .js file.", vim.log.levels.WARN)
    end, { desc = "Debug Playwright Test File" })

    vim.keymap.set("n", "<leader>dpc", function()
      -- Run the Playwright configuration (will prompt to select if multiple configs)
      vim.cmd("DapContinue")
    end, { desc = "Debug Playwright Test" })
  end,
}

--                                                   
--                                                   
--                                                   
--                
