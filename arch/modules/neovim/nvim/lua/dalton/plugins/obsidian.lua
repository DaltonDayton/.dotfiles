return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>on",
      function()
        vim.cmd("ObsidianNew")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: New Note",
    },
    {
      "<leader>oo",
      function()
        vim.cmd("ObsidianOpen")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Open Note",
    },
    {
      "<leader>oq",
      function()
        vim.cmd("ObsidianQuickSwitch")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Quick Switch",
    },
    {
      "<leader>of",
      function()
        vim.cmd("ObsidianFollowLink")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Follow Link",
    },
    {
      "<leader>ob",
      function()
        vim.cmd("ObsidianBacklinks")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Backlinks",
    },
    {
      "<leader>ot",
      function()
        vim.cmd("ObsidianTags")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Tags",
    },
    {
      "<leader>od",
      function()
        vim.cmd("ObsidianToday")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Today",
    },
    {
      "<leader>oy",
      function()
        vim.cmd("ObsidianYesterday")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Yesterday",
    },
    {
      "<leader>om",
      function()
        vim.cmd("ObsidianTomorrow")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Tomorrow",
    },
    {
      "<leader>oi",
      function()
        vim.cmd("ObsidianTemplate")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Insert Template",
    },
    {
      "<leader>os",
      function()
        vim.cmd("ObsidianSearch")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Search",
    },
    {
      "<leader>ol",
      function()
        vim.cmd("ObsidianLink")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Link",
    },
    {
      "<leader>oa",
      function()
        vim.cmd("ObsidianLinkNew")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Link New",
    },
    {
      "<leader>oL",
      function()
        vim.cmd("ObsidianLinks")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Links",
    },
    {
      "<leader>oe",
      function()
        vim.cmd("ObsidianExtractNote")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Extract Note",
    },
    {
      "<leader>ow",
      function()
        vim.cmd("ObsidianWorkspace")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Workspace",
    },
    {
      "<leader>op",
      function()
        vim.cmd("ObsidianPasteImg")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Paste Image",
    },
    {
      "<leader>or",
      function()
        vim.cmd("ObsidianRename")
      end,
      { noremap = true, silent = true },
      desc = "Obsidian: Rename",
    },
  },
  opts = {
    ui = {
      enable = false,
    },
    workspaces = {
      {
        name = "personal",
        path = "~/vaults/Personal",
      },
      {
        name = "work",
        path = "~/vaults/Work",
      },
    },
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
    notes_subdir = "6 - Main Notes",
    new_notes_location = "notes_subdir",
    disable_frontmatter = true,

    templates = {
      subdir = "5 - Templates",
      date_format = "%d %b %Y",
      time_format = "%H:%m",
    },

    attachments = {
      img_folder = "0 - Files",
    },

    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,
  },
}
