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

    -- ========================================================================
    -- SECURITY: Validate and Register js-debug-adapter (pwa-node)
    -- ========================================================================
    local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

    if vim.fn.filereadable(js_debug_path) == 1 then
      -- Manually register js-debug-adapter (pwa-node) since mason-nvim-dap doesn't do it automatically
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug_path, "${port}" },
        },
      }

      -- Register aliases for compatibility
      dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]
      dap.adapters["node"] = dap.adapters["pwa-node"]
    else
      vim.notify(
        "js-debug-adapter not found at: "
          .. js_debug_path
          .. "\nRun :MasonInstall js-debug-adapter to enable JavaScript/TypeScript debugging",
        vim.log.levels.WARN
      )
    end

    -- ========================================================================
    -- Playwright Test Configurations
    -- ========================================================================
    local function setup_playwright_configs()
      if not dap.adapters["pwa-node"] then
        return -- Skip if adapter not available
      end

      dap.configurations.typescript = dap.configurations.typescript or {}
      dap.configurations.javascript = dap.configurations.javascript or {}

      local playwright_config = {
        type = "pwa-node",
        request = "launch",
        name = "Debug Playwright Test (File)",
        runtimeExecutable = "npx",
        runtimeArgs = { "playwright", "test", "--headed", "--timeout", "0" },
        args = { "${file}" },
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      }

      table.insert(dap.configurations.typescript, playwright_config)
      table.insert(dap.configurations.javascript, vim.deepcopy(playwright_config))
    end

    setup_playwright_configs()

    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )

    -- ========================================================================
    -- SECURITY: Log Point Message Sanitization
    -- ========================================================================
    local function sanitize_log_message(message)
      if not message or type(message) ~= "string" then return nil end

      -- SECURITY: Length validation
      if #message > 500 then
        vim.notify("Log message too long (max 500 chars)", vim.log.levels.ERROR)
        return nil
      end

      -- SECURITY: Reject messages with code injection patterns
      local dangerous_patterns = {
        { pattern = "%${", name = "template literal" },
        { pattern = "process%.env", name = "environment access" },
        { pattern = "require%(", name = "module loading" },
        { pattern = "eval%(", name = "code evaluation" },
        { pattern = "Function%(", name = "constructor injection" },
      }

      for _, check in ipairs(dangerous_patterns) do
        if message:match(check.pattern) then
          vim.notify("Log message contains potentially dangerous pattern: " .. check.name, vim.log.levels.ERROR)
          return nil
        end
      end

      return message
    end

    -- Keybinds
    vim.keymap.set("n", "<F5>", function() require("dap").continue() end, { desc = "Continue" })
    vim.keymap.set("n", "<F7>", function() require("dap").step_over() end, { desc = "Step Over" })
    vim.keymap.set("n", "<F8>", function() require("dap").step_into() end, { desc = "Step Into" })
    vim.keymap.set("n", "<F9>", function() require("dap").step_out() end, { desc = "Step Out" })
    vim.keymap.set("n", "<Leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<Leader>dL", function()
      local input = vim.fn.input("Log point message: ")
      local sanitized = sanitize_log_message(input)
      if sanitized then require("dap").set_breakpoint(nil, nil, sanitized) end
    end, { desc = "Set Log Point" })

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
