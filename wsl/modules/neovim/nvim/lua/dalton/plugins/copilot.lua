return {
  { -- Copilot
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  { -- Copilot Chat
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
      debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
      disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
      language = "English", -- Copilot answer language settings when using default prompts. Default language is English.
      -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
      -- temperature = 0.1,
      mappings = {
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        reset = {
          normal = "<leader>ccr",
          insert = "<leader>ccr",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        yank_diff = {
          normal = "gy",
          register = '"',
        },
        show_diff = {
          normal = "gd",
        },
        show_system_prompt = {
          normal = "gp",
        },
        show_user_selection = {
          normal = "gs",
        },
      },
    },
    build = function()
      vim.cmd("UpdateRemotePlugins")
    end,
    event = "VeryLazy",
    -- stylua: ignore start
    keys = {
      { "<leader>ccc", ":CopilotChat ",                     mode = { "n", "v" }, desc = "CopilotChat - Open chat window with optional input" },
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>",       mode = { "n", "v" }, desc = "CopilotChat - Explain code" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>",         mode = { "n", "v" }, desc = "CopilotChat - Generate tests" },
      { "<leader>ccT", "<cmd>CopilotChatToggle<cr>",        mode = { "n", "v" }, desc = "CopilotChat - Toggle chat window" },
      { "<leader>ccf", "<cmd>CopilotChatFixDiagnostic<cr>", mode = { "n", "v" }, desc = "CopilotChat - Fix diagnostic" },
      { "<leader>ccr", "<cmd>CopilotChatReset<cr>",         mode = { "n", "v" }, desc = "CopilotChat - Reset chat history and clear buffer" },
    },
    -- stylua: ignore end
  },
  { -- Copilot Cmp
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
