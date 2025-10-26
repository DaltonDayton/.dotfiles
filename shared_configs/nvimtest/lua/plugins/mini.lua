return {
  {
    "nvim-mini/mini.completion",
    version = false,
    config = function()
      require("mini.completion").setup()

      -- Disable mini.completion in specified buffers. (:set filetype to check)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "snacks_picker_input" },
        callback = function() vim.b.minicompletion_disable = true end,
      })
    end,
  },
  {
    "nvim-mini/mini.pairs",
    version = false,
    config = function() require("mini.pairs").setup() end,
  },
}
