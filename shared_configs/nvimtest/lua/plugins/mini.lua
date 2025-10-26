return {
  { "nvim-mini/mini.icons", version = false },
  {
    "nvim-mini/mini.pairs",
    version = false,
    config = function() require("mini.pairs").setup() end,
  },
}
