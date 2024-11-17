return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    -- Function to display recording macro message
    local function macro_recording()
      local recording_reg = vim.fn.reg_recording()
      if recording_reg ~= "" then
        return "Recording @" .. recording_reg
      else
        return ""
      end
    end

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = "catppuccin",
      },
      sections = {
        lualine_c = {
          { macro_recording },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
