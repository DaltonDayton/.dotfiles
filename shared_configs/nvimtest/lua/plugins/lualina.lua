return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-mini/mini.icons" },
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
          {
            "filename",
            path = 1, -- Show relative path (0 = just filename, 1 = relative path, 2 = absolute path)
            file_status = true, -- Shows file modification status
            newfile_status = true, -- Shows if file is new
            symbols = {
              modified = "[+]", -- Symbol for modified files
              readonly = "[-]", -- Symbol for readonly files
              unnamed = "[No Name]", -- Symbol for unnamed buffers
              newfile = "[New]", -- Symbol for new files
            },
          },
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
