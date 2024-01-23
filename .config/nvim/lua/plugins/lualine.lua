return {
    'nvim-lualine/lualine.nvim',
    event = 'ColorScheme',
    config = function()
        require('lualine').setup({
            options = {
                --- @usage 'rose-pine' | 'rose-pine-alt'
                theme = 'rose-pine'
            }
        })
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' }
}
