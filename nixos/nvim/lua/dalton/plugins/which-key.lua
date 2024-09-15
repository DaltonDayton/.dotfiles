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
  config = function() -- This is the function that runs, AFTER loading
    require("which-key").setup()

    -- Document existing key chains
    require("which-key").add({
      { "<leader>b", group = "[B]uffer/Data[B]ase" },
      { "<leader>b_", hidden = true },
      { "<leader>c", group = "[C]ode / [C]opilot [C]hat" },
      { "<leader>c_", hidden = true },
      { "<leader>cc", group = "[C]opilot [C]hat" },
      { "<leader>cc_", hidden = true },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>d_", hidden = true },
      { "<leader>e", group = "[E]xplorer" },
      { "<leader>e_", hidden = true },
      { "<leader>h", group = "[H]unk (Git)" },
      { "<leader>h_", hidden = true },
      { "<leader>i", group = "[I]lluminate" },
      { "<leader>i_", hidden = true },
      { "<leader>l", group = "[L]azy Git" },
      { "<leader>l_", hidden = true },
      { "<leader>m", group = "[M]ake Pretty" },
      { "<leader>m_", hidden = true },
      { "<leader>n", group = "[N]eoTest" },
      { "<leader>n_", hidden = true },
      { "<leader>o", group = "[O]bsidian" },
      { "<leader>o_", hidden = true },
      { "<leader>s", group = "[S]earch" },
      { "<leader>s_", hidden = true },
      { "<leader>t", group = "[T]rouble" },
      { "<leader>t_", hidden = true },
      { "<leader>u", group = "[U]ndotree" },
      { "<leader>u_", hidden = true },
    })
  end,
}
