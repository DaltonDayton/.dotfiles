return {
  {
    "echasnovski/mini.nvim",
    main = "mini",
    opts = {},
    dependencies = {},
    config = function()
      require("mini.icons").setup()
      require("mini.pairs").setup()
      require("mini.surround").setup()
    end,
  },
}
