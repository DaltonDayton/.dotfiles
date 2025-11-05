return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function()
    require("which-key").setup()

    -- Document key groups only - individual keybinds have their own desc where defined
    require("which-key").add({
      -- LSP Navigation
      { "g", group = "[G]oto" },
      { "ga", group = "LSP C[a]lls" },

      -- Leader groups
      { "<leader>b", group = "[B]uffer" },
      { "<leader>b_", hidden = true },
      { "<leader>c", group = "[C]ode" },
      { "<leader>c_", hidden = true },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>d_", hidden = true },
      { "<leader>e", group = "[E]xplorer" },
      { "<leader>e_", hidden = true },
      { "<leader>f", group = "[F]ind" },
      { "<leader>f_", hidden = true },
      { "<leader>g", group = "[G]it" },
      { "<leader>g_", hidden = true },
      { "<leader>h", group = "[H]unk" },
      { "<leader>h_", hidden = true },
      { "<leader>m", group = "[M]ake Pretty" },
      { "<leader>m_", hidden = true },
      { "<leader>n", group = "[N]eotest" },
      { "<leader>n_", hidden = true },
      { "<leader>np", group = "[P]laywright" },
      { "<leader>np_", hidden = true },
      { "<leader>s", group = "[S]earch" },
      { "<leader>s_", hidden = true },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>t_", hidden = true },
      { "<leader>u", group = "[U]I Toggles" },
      { "<leader>u_", hidden = true },
    })
  end,
}
