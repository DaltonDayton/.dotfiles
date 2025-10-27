return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    local dap = require("dap")
    local ui = require("dapui")
    local virtual_text = require("nvim-dap-virtual-text")

    ui.setup()
    virtual_text.setup({})

    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )

    -- Keybinds
    vim.keymap.set("n", "<F5>", function() require("dap").continue() end)
    vim.keymap.set("n", "<F10>", function() require("dap").step_over() end)
    vim.keymap.set("n", "<F11>", function() require("dap").step_into() end)
    vim.keymap.set("n", "<F12>", function() require("dap").step_out() end)
    vim.keymap.set("n", "<Leader>db", function() require("dap").toggle_breakpoint() end)
    vim.keymap.set("n", "<Leader>dp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
    vim.keymap.set("n", "<Leader>dr", function() require("dap").repl.open() end)
    vim.keymap.set("n", "<Leader>dl", function() require("dap").run_last() end)
    vim.keymap.set({ "n", "v" }, "<Leader>dh", function() require("dap.ui.widgets").hover() end)
    vim.keymap.set({ "n", "v" }, "<Leader>dp", function() require("dap.ui.widgets").preview() end)
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
  end,
}

--                                                   
--                                                   
--                                                   
--                
