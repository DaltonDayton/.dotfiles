return {
    'VonHeikemen/lsp-zero.nvim',
    lazy = false, -- This plugin is loaded at startup, not lazily loaded.
    dependencies = {
        -- Core LSP plugins for enhanced coding experience in Neovim:
        'neovim/nvim-lspconfig',             -- Basic Neovim LSP configurations
        'williamboman/mason.nvim',           -- Manages installation of LSP servers and other tools
        'williamboman/mason-lspconfig.nvim', -- Integrates Mason with nvim-lspconfig

        -- Autocompletion setup:
        'hrsh7th/nvim-cmp',                  -- The main autocompletion plugin
        'hrsh7th/cmp-nvim-lsp',              -- Allows nvim-cmp to use Neovim's LSP as a source for completion
        'hrsh7th/cmp-buffer',                -- Buffer completions for nvim-cmp
        'hrsh7th/cmp-path',                  -- Path completions for nvim-cmp
        'saadparwaiz1/cmp_luasnip',          -- Snippet completions for nvim-cmp
        'hrsh7th/cmp-nvim-lua',              -- Lua completions for nvim-cmp (useful for configuring Neovim in Lua)

        -- Snippet support:
        'L3MON4D3/LuaSnip',                  -- Snippet engine
        'rafamadriz/friendly-snippets',      -- A collection of snippets for multiple languages
    },
    config = function()
        local lsp_zero = require('lsp-zero')

        lsp_zero.preset("recommended") -- Use the recommended default settings

        lsp_zero.on_attach(function(client, bufnr)
            -- Setup default key mappings and symbol highlighting on attach
            lsp_zero.default_keymaps({ buffer = bufnr })
            lsp_zero.highlight_symbol(client, bufnr)
        end)

        -- Customize diagnostic sign icons
        lsp_zero.set_sign_icons({
            error = '✘', -- Custom icon for errors
            warn = '▲',  -- Custom icon for warnings
            hint = '⚑',  -- Custom icon for hints
            info = '»'   -- Custom icon for informational messages
        })

        -- Mason configuration for automatic LSP server management
        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = { "lua_ls" }, -- Ensure the Lua LSP server is installed
            automatic_installation = true,   -- Automatically install missing LSP servers
            handlers = {
                lsp_zero.default_setup,      -- Default handler for all LSP servers
                lua_ls = function()
                    local lua_opts = lsp_zero.nvim_lua_ls() -- Get default options for Lua LSP
                    require("lspconfig").lua_ls.setup(lua_opts)
                end
            },
        })

        -- nvim-cmp setup for autocompletion
        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        require('luasnip.loaders.from_vscode').lazy_load() -- Load snippets from friendly-snippets

        cmp.setup({
            sources = cmp.config.sources({
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'nvim_lua' },
                { name = 'luasnip', keyword_length = 2 },
                { name = 'buffer',  keyword_length = 3 },
            }),
            formatting = lsp_zero.cmp_format(), -- Use lsp-zero's formatting for completion items
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
        })
    end
}
