return {
  "christoomey/vim-tmux-navigator",
  "folke/which-key.nvim",
  "tpope/vim-sleuth",

  { "nvim-tree/nvim-web-devicons", opts = {} },
  { "nvim-mini/mini.icons", version = false },
  { "folke/neoconf.nvim", cmd = "Neoconf" },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
