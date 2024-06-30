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
      --      ["<leader>e"] = { name = "[E]xplorer", _ = "which_key_ignore" },
      --      ["<leader>h"] = { name = "Misc Git Stuff", _ = "which_key_ignore" },
      ["<leader>l"] = { name = "[L]azy Git", _ = "which_key_ignore" },
      ["<leader>m"] = { name = "[M]ake Pretty", _ = "which_key_ignore" },
      --      ["<leader>o"] = { name = "[O]bsidian", _ = "which_key_ignore" },
      --      ["<leader>r"] = { name = "[R]e", _ = "which_key_ignore" },
      --      ["<leader>t"] = { name = "[T]abs", _ = "which_key_ignore" },
      ["<leader>u"] = { name = "[U]ndotree", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
      --      ["<leader>w"] = { name = "[W]indow", _ = "which_key_ignore" },
      --      ["<leader>x"] = { name = "Trouble", _ = "which_key_ignore" },
    })
  end,
}
