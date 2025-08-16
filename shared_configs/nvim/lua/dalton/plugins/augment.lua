return {
  "augmentcode/augment.vim",
  event = "InsertEnter",
  config = function()
    -- vim.g.augment_workspace_folders = { "/home/dalton/.dotfiles/" }
    -- vim.g.augment_workspace_folders = { "/home/dalton/repos" }
    local root_dir = vim.lsp.buf.list_workspace_folders()[1] or vim.fn.getcwd()
    vim.g.augment_workspace_folders = { root_dir }

    vim.g.augment_disable_tab_mapping = true
    vim.keymap.set('i', '<C-y>', '<cmd>call augment#Accept()<CR>', { silent = true })
  end,
  keys = {
    { "<leader>ae",  "<cmd>Augment enable<cr>",                                mode = { "n" },      desc = "Augment - Enable suggestions" },
    { "<leader>ad",  "<cmd>Augment disable<cr>",                               mode = { "n" },      desc = "Augment - Disable suggestions" },
    { "<leader>am",  "<cmd>Augment chat<cr>",                                  mode = { "n", "v" }, desc = "Augment - Send chat message" },
    { "<leader>an",  "<cmd>Augment chat-new<cr>",                              mode = { "n" },      desc = "Augment - New chat" },
    { "<leader>at",  "<cmd>Augment chat-toggle<cr>",                           mode = { "n" },      desc = "Augment - Toggle chat" },
    { "<leader>as",  "<cmd>Augment status<cr>",                                mode = { "n" },      desc = "Augment - View status" },
    { "<leader>al",  "<cmd>Augment log<cr>",                                   mode = { "n" },      desc = "Augment - View log" },
    -- { "<leader>ai", "<cmd>Augment signin<cr>",      mode = { "n" }, desc = "Augment - Sign in" },
    -- { "<leader>ao", "<cmd>Augment signout<cr>",     mode = { "n" }, desc = "Augment - Sign out" },
    { "<leader>ace", "<cmd>lua vim.g.augment_disable_completions = false<cr>", mode = { "n" },      desc = "Augment - Enable completions" },
    { "<leader>acd", "<cmd>lua vim.g.augment_disable_completions = true<cr>",  mode = { "n" },      desc = "Augment - Disable completions" },
  },
}
