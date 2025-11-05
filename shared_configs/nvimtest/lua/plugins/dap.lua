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
    vim.keymap.set({ "n", "v" }, "<Leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "Hover" })
    vim.keymap.set({ "n", "v" }, "<Leader>dP", function() require("dap.ui.widgets").preview() end, { desc = "Preview" })
    vim.keymap.set("n", "<Leader>df", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames)
    end, { desc = "Frames" })

    vim.keymap.set("n", "<Leader>ds", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end, { desc = "Scopes" })

    -- Dap UI
    vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle UI" })
    dap.listeners.before.attach.dapui_config = function() ui.open() end
    dap.listeners.before.launch.dapui_config = function() ui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
    dap.listeners.before.event_exited.dapui_config = function() ui.close() end

    -- Playwright-specific DAP keybindings
    vim.keymap.set("n", "<leader>dpt", function()
      -- Debug entire file
      local config = {
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
      dap.run(config)
    end, { desc = "Debug Playwright Test File" })

    vim.keymap.set("n", "<leader>dpc", function()
      -- Debug test at cursor line
      local file = vim.fn.expand("%:p") -- absolute path
      local cwd = vim.fn.getcwd()
      local relative_file = vim.fn.fnamemodify(file, ":.") -- make relative to cwd
      local line = vim.fn.line(".")

      -- Function to find test name using Treesitter
      local function find_test_name(cursor_line)
        local buf = vim.api.nvim_get_current_buf()

        -- Check if treesitter is available for this buffer
        local ok, parser = pcall(vim.treesitter.get_parser, buf)
        if not ok then
          vim.notify("Treesitter not available for this file", vim.log.levels.WARN)
          return nil, nil
        end

        local tree = parser:parse()[1]
        local root = tree:root()

        -- Convert 1-indexed line to 0-indexed for treesitter
        local cursor_row = cursor_line - 1

        -- Find the node at the cursor position
        local node = root:descendant_for_range(cursor_row, 0, cursor_row, 999)

        -- Walk up the tree to find a call_expression that's a test
        while node do
          if node:type() == "call_expression" then
            -- Check if this is a test call (test, test.only, test.skip, etc.)
            local func_node = node:field("function")[1]
            if func_node then
              local func_text = vim.treesitter.get_node_text(func_node, buf)
              if func_text and func_text:match("^test") then
                -- Found a test call - get the first argument (test name)
                local args = node:field("arguments")[1]
                if args then
                  -- Get first argument (the string with test name)
                  local first_arg = args:field("0")[1]
                  if not first_arg then
                    -- Try alternative way to get first child
                    for child in args:iter_children() do
                      if child:type() == "string" or child:type() == "template_string" then
                        first_arg = child
                        break
                      end
                    end
                  end

                  if first_arg then
                    local test_name = vim.treesitter.get_node_text(first_arg, buf)
                    -- Remove quotes from string
                    test_name = test_name:gsub("^[\"']", ""):gsub("[\"']$", "")
                    local start_row, _, _, _ = node:range()
                    return test_name, start_row + 1 -- Convert back to 1-indexed
                  end
                end
              end
            end
          end
          node = node:parent()
        end

        return nil, nil
      end

      local test_name, found_line = find_test_name(line)

      if test_name then
        vim.notify("Running test: " .. test_name, vim.log.levels.INFO)
        local config = {
          type = "pwa-node",
          request = "launch",
          name = "Debug Playwright Test (at cursor)",
          runtimeExecutable = "npx",
          runtimeArgs = { "playwright", "test", "--headed", "--timeout", "0", "-g", test_name },
          args = { relative_file },
          cwd = cwd,
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        }
        dap.run(config)
      else
        vim.notify(
          "Could not find test name at or above cursor. Make sure cursor is inside a test() block.",
          vim.log.levels.ERROR
        )
      end
    end, { desc = "Debug Playwright Test at Cursor" })
  end,
}

--                                                   
--                                                   
--                                                   
--                
