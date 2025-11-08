return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    -- Toggle harpoon menu
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle Harpoon menu" })

    -- Add to harpoon list (Harpoon-specific)
    vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end, { desc = "Add to Harpoon" })

    -- Standard vim marks
    vim.keymap.set("n", "<leader>ml", function() Snacks.picker.marks() end, { desc = "List marks" })
    vim.keymap.set("n", "<leader>md", function()
      local mark = vim.fn.input("Delete mark: ")
      if mark ~= "" then
        vim.cmd("delmarks " .. mark)
        vim.notify("Deleted mark: " .. mark, vim.log.levels.INFO)
      end
    end, { desc = "Delete mark" })
    vim.keymap.set("n", "<leader>mD", function()
      vim.cmd("delmarks!")
      vim.notify("Deleted all marks in current buffer", vim.log.levels.INFO)
    end, { desc = "Delete all marks (buffer)" })
    vim.keymap.set("n", "<leader>mX", function()
      vim.cmd("delmarks A-Z0-9")
      vim.notify("Deleted all global marks", vim.log.levels.WARN)
    end, { desc = "Delete all global marks" })

    -- Select harpoon marks
    vim.keymap.set("n", "<M-j>", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
    vim.keymap.set("n", "<M-k>", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
    vim.keymap.set("n", "<M-l>", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
    vim.keymap.set("n", "<M-;>", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

    -- Navigate harpoon list
    vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Previous Harpoon mark" })
    vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Next Harpoon mark" })
  end,
}
