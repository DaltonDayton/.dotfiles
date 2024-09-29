return {
  "christoomey/vim-tmux-navigator",
  "tpope/vim-sleuth",
  "echasnovski/mini.icons",
  {
    "RRethy/vim-illuminate",
    config = function()
      -- stylua: ignore start
      vim.keymap.set('n', '<leader>in', function() require('illuminate').goto_next_reference(true) end, { desc = "Go to next reference" })
      vim.keymap.set('n', '<leader>ip', function() require('illuminate').goto_prev_reference(true) end, { desc = "Go to previous reference" })
      vim.keymap.set('n', '<leader>is', function() require('illuminate').textobj_select() end, { desc = "Select text object" })
      -- stylua: ignore end
    end,
  },
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>ms", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
    },
  },
}
