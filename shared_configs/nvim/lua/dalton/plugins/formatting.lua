return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- javascript = { "prettier" },
          -- typescript = { "prettier" },
          -- javascriptreact = { "prettier" },
          -- typescriptreact = { "prettier" },
          -- svelte = { "prettier" },
          -- css = { "prettier" },
          -- html = { "prettier" },
          -- json = { "prettier" },
          -- yaml = { "prettier" },
          -- markdown = { "prettier" },
          -- graphql = { "prettier" },
          -- liquid = { "prettier" },
          -- lua = { "stylua" },
          -- python = { "isort", "black" },
          -- sql = { "sql_formatter" },
          -- eruby = { "erb_format" },
        },
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 1000, lsp_fallback = true } -- Adjust timeout as needed
        end,
      })

      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })

      vim.keymap.set("n", "<leader>ma", function()
        vim.cmd("FormatToggle")
      end, { desc = "Toggle format on save" })
    end,
  },
  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
    config = function()
      require("mason-conform").setup({})
    end,
  },
}
