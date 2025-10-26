return {
  "nvim-neotest/neotest",
  dependencies = {
    -- Core
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Adapters
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-vim-test",
  },
  config = function()
    local neotest = require("neotest")
    neotest.setup({
      output = {
        open_on_run = true,
      },
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      floating = {
        border = "rounded",
        max_height = 0.8,
        max_width = 0.8,
      },
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
          -- instances for files containing a parametrize mark (default: false)
          pytest_discover_instances = true,
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
  end,
}
