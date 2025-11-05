return {
  "nvim-neotest/neotest",
  dependencies = {
    -- Core
    -- "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Adapters
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-vim-test",
    "nsidorenco/neotest-vstest",
    "thenbe/neotest-playwright",
  },
  config = function()
    local neotest = require("neotest")
    neotest.setup({
      output = {
        open_on_run = true,
      },
      floating = {
        border = "rounded",
        max_height = 0.8,
        max_width = 0.8,
      },
      adapters = {
        -- Python
        require("neotest-python")({
          dap = { justMyCode = false },
          -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
          -- instances for files containing a parametrize mark (default: false)
          pytest_discover_instances = true,
        }),

        -- C# / dotnet
        require("neotest-vstest")({
          -- Path to dotnet sdk path.
          -- Used in cases where the sdk path cannot be auto discovered.
          -- sdk_path = "/usr/local/dotnet/sdk/9.0.101/",
          -- table is passed directly to DAP when debugging tests.
          dap_settings = {
            type = "coreclr",
          },
          -- If multiple solutions exists the adapter will ask you to choose one.
          -- If you have a different heuristic for choosing a solution you can provide a function here.
          solution_selector = function(solutions)
            return nil -- return the solution you want to use or nil to let the adapter choose.
          end,
          build_opts = {
            -- Arguments that will be added to all `dotnet build` and `dotnet msbuild` commands
            additional_args = {},
          },
        }),

        -- Playwright
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            preset = "none", -- "none" | "headed" | "debug"
            get_cwd = function() return vim.fn.getcwd() end,
            -- Additional Playwright options for better debugging
            get_playwright_binary = function() return vim.loop.cwd() .. "/node_modules/.bin/playwright" end,
            -- Custom environment variables for debugging
            env = {
              -- Enable trace on first retry for debugging
              PWDEBUG = "0", -- Set to "1" for playwright inspector
            },
            -- Filter test files
            filter_dir = function(name) return name ~= "node_modules" and name ~= ".git" end,
          },
        }),

        -- neotest-vim-test for test runners not available by default neotest
        require("neotest-vim-test")({ ignore_filetypes = { "python", "lua", "typescript", "javascript" } }),
      },
    })

    -- Keybinds
    vim.keymap.set("n", "<leader>nt", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run File" })
    vim.keymap.set("n", "<leader>nT", function() neotest.run.run(vim.uv.cwd()) end, { desc = "Run All Test Files" })
    vim.keymap.set("n", "<leader>nr", function() neotest.run.run() end, { desc = "Run Nearest" })
    vim.keymap.set("n", "<leader>nl", function() neotest.run.run_last() end, { desc = "Run Last" })
    vim.keymap.set("n", "<leader>nd", function() neotest.run.run({ strategy = "dap" }) end, { desc = "Debug Nearest" })
    vim.keymap.set("n", "<leader>ns", function() neotest.summary.toggle() end, { desc = "Toggle Summary" })
    vim.keymap.set(
      "n",
      "<leader>no",
      function() neotest.output.open({ enter = true, auto_close = false }) end,
      { desc = "Show Output" }
    )
    vim.keymap.set("n", "<leader>nO", function() neotest.output_panel.toggle() end, { desc = "Toggle Output Panel" })
    vim.keymap.set("n", "<leader>nS", function() neotest.run.stop() end, { desc = "Stop" })
    vim.keymap.set("n", "<leader>nw", function() neotest.watch.toggle(vim.fn.expand("%")) end, { desc = "Toggle Watch" })
    vim.keymap.set("n", "[t", function() neotest.jump.prev({ status = "failed" }) end, { desc = "Previous failed test" })
    vim.keymap.set("n", "]t", function() neotest.jump.next({ status = "failed" }) end, { desc = "Next failed test" })

    -- Playwright-specific keybindings
    vim.keymap.set(
      "n",
      "<leader>nph",
      function()
        neotest.run.run({
          extra_args = { "--headed" },
          env = { PWDEBUG = "0" },
        })
      end,
      { desc = "Run Nearest (Headed)" }
    )

    vim.keymap.set("n", "<leader>npi", function()
      neotest.run.run({
        env = { PWDEBUG = "1" }, -- Opens Playwright Inspector
      })
    end, { desc = "Run with Playwright Inspector" })

    vim.keymap.set("n", "<leader>npt", function()
      neotest.run.run({
        extra_args = { "--trace", "on" },
      })
      vim.notify("Test run with trace recording. Use 'npx playwright show-trace' to view.", vim.log.levels.INFO)
    end, { desc = "Run with Trace" })

    vim.keymap.set("n", "<leader>npD", function()
      neotest.run.run({
        extra_args = { "--debug" }, -- Uses Playwright's native debugger
      })
    end, { desc = "Debug with Playwright Debugger" })

    -- Playwright CLI shortcuts
    vim.keymap.set(
      "n",
      "<leader>npc",
      function() vim.cmd("terminal npx playwright codegen") end,
      { desc = "Open Playwright Codegen" }
    )

    vim.keymap.set(
      "n",
      "<leader>npv",
      function() vim.cmd("terminal npx playwright show-trace") end,
      { desc = "Open Trace Viewer" }
    )

    -- Playwright DAP debugging (neotest-playwright doesn't support DAP strategy)
    vim.keymap.set("n", "<leader>npd", function()
      local file_path = vim.fn.expand("%:p")
      local cursor_line = vim.fn.line(".")
      local buf = vim.api.nvim_get_current_buf()

      -- Find test name using Treesitter
      local function find_test_name()
        local ok, parser = pcall(vim.treesitter.get_parser, buf)
        if not ok then return nil end

        local tree = parser:parse()[1]
        local root = tree:root()
        local node = root:descendant_for_range(cursor_line - 1, 0, cursor_line - 1, 999)

        while node do
          if node:type() == "call_expression" then
            local func_node = node:field("function")[1]
            if func_node then
              local func_text = vim.treesitter.get_node_text(func_node, buf)
              if func_text and func_text:match("^test") then
                local args = node:field("arguments")[1]
                if args then
                  local first_arg = args:field("0")[1]
                  if not first_arg then
                    for child in args:iter_children() do
                      if child:type() == "string" or child:type() == "template_string" then
                        first_arg = child
                        break
                      end
                    end
                  end
                  if first_arg then
                    local test_name = vim.treesitter.get_node_text(first_arg, buf)
                    return test_name:gsub("^[\"']", ""):gsub("[\"']$", "")
                  end
                end
              end
            end
          end
          node = node:parent()
        end
        return nil
      end

      local test_name = find_test_name()
      if not test_name then
        vim.notify("No Playwright test found at cursor", vim.log.levels.WARN)
        return
      end

      vim.notify("Debugging Playwright test: " .. test_name, vim.log.levels.INFO)
      require("dap").run({
        type = "pwa-node",
        request = "launch",
        name = "Debug Playwright Test",
        runtimeExecutable = "npx",
        runtimeArgs = { "playwright", "test", "--headed", "--timeout", "0", "-g", test_name },
        args = { vim.fn.fnamemodify(file_path, ":.") },
        cwd = vim.fn.getcwd(),
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      })
    end, { desc = "Debug Playwright Test with DAP" })
  end,
}
