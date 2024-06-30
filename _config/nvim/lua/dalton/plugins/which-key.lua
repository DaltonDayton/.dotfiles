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
    require("which-key").register({
      --      ["<leader>b"] = { name = "[B]uffer/Data[B]ase", _ = "which_key_ignore" },
      ["<leader>c"] = { name = "[C]ode / [C]opilot [C]hat", _ = "which_key_ignore" },
      ["<leader>cc"] = { name = "[C]opilot [C]hat", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]ebug", _ = "which_key_ignore" },
      ["<leader>e"] = { name = "[E]xplorer", _ = "which_key_ignore" },
      ["<leader>h"] = { name = "[H]unk (Git)", _ = "which_key_ignore" },
      ["<leader>i"] = { name = "[I]lluminate", _ = "which_key_ignore" },
      ["<leader>l"] = { name = "[L]azy Git", _ = "which_key_ignore" },
      ["<leader>m"] = { name = "[M]ake Pretty", _ = "which_key_ignore" },
      ["<leader>o"] = { name = "[O]bsidian", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]rouble", _ = "which_key_ignore" },
      ["<leader>u"] = { name = "[U]ndotree", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
    })
  end,
}
