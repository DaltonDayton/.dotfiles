return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        require("rose-pine").setup({
            variant = main,
            dark_variant = main,
            dim_inactive_windows = false,
            styles = {
                transparency = true,
            },
        })
        -- Load the color scheme
        vim.cmd("colorscheme rose-pine")

        -- Set background color for Normal and NormalFloat highlight groups
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
}
