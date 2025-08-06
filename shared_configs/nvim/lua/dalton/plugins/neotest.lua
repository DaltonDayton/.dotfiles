return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-vim-test",
    "vim-test/vim-test",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "thenbe/neotest-playwright",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          -- Extra arguments for nvim-dap configuration
          -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
          dap = { justMyCode = false },
          -- Command line arguments for runner
          -- Can also be a function to return dynamic values
          args = { "--log-level", "DEBUG" },
          -- Runner to use. Will use pytest if available by default.
          -- Can be a function to return dynamic value.
          runner = "pytest",
          -- Custom python path for the runner.
          -- Can be a string or a list of strings.
          -- Can also be a function to return dynamic value.
          -- If not provided, the path will be inferred by checking for
          -- virtual envs in the local directory and for Pipenev/Poetry configs
          python = ".venv/bin/python",
          -- Returns if a given file path is a test file.
          -- NB: This function is called a lot so don't perform any heavy tasks within it.
          -- is_test_file = function(file_path)
          --   ...
          -- end,
          -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
          -- instances for files containing a parametrize mark (default: false)
          pytest_discover_instances = true,
        }),

        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            preset = "none", -- Can be "none", "headed", or "debug"
          },
        }),

        -- neotest-vim-test for test runners not available by default neotest
        require("neotest-vim-test")({ ignore_filetypes = { "python", "lua", "typescript", "javascript" } }),
        -- Or to only allow specified file types
        -- require("neotest-vim-test")({ allow_file_types = { "csharp" } }),
      },
    })
  end,
  -- stylua: ignore
  keys = {
    { "<leader>nt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>nT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
    { "<leader>nr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>nl", function() require("neotest").run.run_last() end, desc = "Run Last" },
    { "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    { "<leader>no", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>nO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    { "<leader>nS", function() require("neotest").run.stop() end, desc = "Stop" },
    { "<leader>nw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
    { "<leader>nd", function() 
        -- Check if current file is a playwright test
        local file_path = vim.fn.expand("%:p")
        if string.match(file_path, "%.spec%.") or string.match(file_path, "%.test%.") then
          -- For playwright tests, use built-in debug mode
          require("neotest").run.run({
            extra_args = {"--debug"}
          })
        else
          -- For other tests (like Python), use DAP
          require("neotest").run.run({strategy = "dap"})
        end
      end, desc = "Run with Debug" },
    { "<leader>npd", function() 
        -- Run with debug flags for playwright
        require("neotest").run.run({
          extra_args = {"--debug"}
        })
      end, desc = "Run Playwright with Debug" },
    { "<leader>nph", function()
        -- Run with headed mode for playwright  
        require("neotest").run.run({
          extra_args = {"--headed", "--retries", "0", "--timeout", "0", "--workers", "1", "--max-failures", "0"}
        })
      end, desc = "Run Playwright Headed" },
  },
}
