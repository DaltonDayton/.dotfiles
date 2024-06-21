return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "ruby_lsp",
      },
    })

    require("mason-nvim-dap").setup({
      automatic_installation = true,
      ensure_installed = {
        "python",
      },
      handlers = {
        function(config)
          -- all sources with no handler get passed here

          -- Keep original functionality

          require("mason-nvim-dap").default_setup(config)
        end,

        -- python = function(config)
        --   config.adapters = {
        --     type = "executable",
        --     command = "/usr/bin/python3",
        --     args = {
        --       "-m",
        --       "debugpy.adapter",
        --     },
        --   }
        --
        --   require("mason-nvim-dap").default_setup(config) -- don't forget this!
        -- end,
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "eslint_d",
      },
    })
  end,
}
