return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "html",
        "cssls",
        "pyright",
        "eslint",
      },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          {
            "mason-org/mason-lspconfig.nvim",
            opts = {},
            dependencies = {
              { "mason-org/mason.nvim", opts = {} },
              "neovim/nvim-lspconfig",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint", -- python linter
        "eslint_d", -- linter
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
