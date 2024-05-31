return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  keys = { "<leader>zz" }, -- TODO: Remove this when v4.6 is available.
  opts = {
    options = {
      mode = "tabs",
      separator_style = "slant",
    },
  },
}
