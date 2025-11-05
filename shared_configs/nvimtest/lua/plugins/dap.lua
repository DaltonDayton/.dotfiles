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
    vim.keymap.set("n", "<F5>", function() require("dap").continue() end, { desc = "Continue" })
    vim.keymap.set("n", "<F7>", function() require("dap").step_over() end, { desc = "Step Over" })
    vim.keymap.set("n", "<F8>", function() require("dap").step_into() end, { desc = "Step Into" })
    vim.keymap.set("n", "<F9>", function() require("dap").step_out() end, { desc = "Step Out" })
    vim.keymap.set("n", "<Leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
    vim.keymap.set(
      "n",
      "<Leader>dL",
      function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
      { desc = "Set Log Point" }
    )

    vim.keymap.set("n", "<Leader>dr", function() require("dap").repl.open() end, { desc = "Open REPL" })
    vim.keymap.set("n", "<Leader>dl", function() require("dap").run_last() end, { desc = "Run Last" })
    vim.keymap.set(
      { "n", "v" },
      "<Leader>dh",
      function() require("dap.ui.widgets").hover(nil, { border = "rounded" }) end,
      { desc = "Hover" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<Leader>dP",
      function() require("dap.ui.widgets").preview(nil, { border = "rounded" }) end,
      { desc = "Preview" }
    )
    vim.keymap.set("n", "<Leader>df", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames, { border = "rounded" })
    end, { desc = "Frames" })

    vim.keymap.set("n", "<Leader>ds", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes, { border = "rounded" })
    end, { desc = "Scopes" })

    -- Dap UI
    vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle UI" })
    dap.listeners.before.attach.dapui_config = function() ui.open() end
    dap.listeners.before.launch.dapui_config = function() ui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
    dap.listeners.before.event_exited.dapui_config = function() ui.close() end

    -- Note: Playwright debugging is now integrated with neotest
    -- Use <leader>nd to debug test at cursor (uses neotest's test discovery)
  end,
}

--                                                   
--                                                   
--                                                   
--                
