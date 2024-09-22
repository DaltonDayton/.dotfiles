return {
  "rcarriga/nvim-notify",
  keys = {
    {
      "<leader>cn",
      function()
        require("notify").dismiss()
      end,
      desc = "Dismiss Notifications",
    },
  },
  config = function()
    require("notify").setup({
      background_colour = "#000000",
      enabled = false,
    })
  end,
}
