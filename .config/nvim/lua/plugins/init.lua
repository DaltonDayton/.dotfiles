--return {
--    { "nvim-tree/nvim-web-devicons", lazy = true },
--    { "MunifTanjim/nui.nvim",        lazy = true },
--    { "nvim-lua/plenary.nvim",       lazy = true },
--    { "tpope/vim-rails",             lazy = true },
--    { "github/copilot.vim",          lazy = false },
--}

local default_plugins = {
    "nvim-lua/plenary.nvim",
    "github/copilot.vim",
}

local config = require("core.utils").load_config()
require("lazy").setup(default_plugins, config.lazy_nvim)

