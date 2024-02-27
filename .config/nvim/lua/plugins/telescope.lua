return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "BurntSushi/ripgrep",
        "nvim-telescope/telescope-fzf-native.nvim",
        "sharkdp/fd"
    },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Telescope: Find Files" },
        { "<leader>fd", "<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files<CR>", desc = "Telescope: Find Files including hidden/.gitignore" },
        { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Telescope: Live Grep" },
        { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Telescope: Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Telescope: Help Tags" },
    },
    config = function()
        require('telescope').setup{
            defaults = {
                mappings = {
                    i = {
                        ["q"] = require('telescope.actions').close,
                    },
                    n = {
                        ["q"] = require('telescope.actions').close,
                    },
                },
            },
        }
    end
}

