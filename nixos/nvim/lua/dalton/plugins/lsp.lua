return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "hrsh7th/cmp-buffer", -- source for text in buffer
        "hrsh7th/cmp-path", -- source for file system paths
        "rafamadriz/friendly-snippets", -- useful snippets
        "onsails/lspkind-nvim", -- vs-code like pictograms
        {
          "L3MON4D3/LuaSnip",
          -- follow latest release.
          version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
          -- install jsregexp (optional!).
          build = "make install_jsregexp",
        },
      },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require("cmp")
      local cmp_action = lsp_zero.cmp_action()

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
        cmp.setup.filetype({ "sql", "mysql" }, {
          sources = {
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
          },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-a>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- formatting = lsp_zero.cmp_format({ details = true }),
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = require("lspkind").cmp_format({
            mode = "symbol_text", -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters
            symbol_map = { Copilot = "" },
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
          }),
        },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      { "jay-babu/mason-nvim-dap.nvim" },
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()

      --- if you want to know more about lsp-zero and mason.nvim
      --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions

        lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })

        -- Helper function to keep keymap line short
        local function set_keymap(key, func, desc)
          local opts = { buffer = bufnr, noremap = true, silent = true, desc = desc }
          vim.keymap.set("n", key, func, opts)
        end

        -- stylua: ignore start
        set_keymap('K', vim.lsp.buf.hover, '[LSP] Hover Info')
        set_keymap('gd', require('telescope.builtin').lsp_definitions, '[LSP/T] Go to Definition')
        set_keymap('gD', vim.lsp.buf.declaration, '[LSP] Go to Declaration')
        set_keymap('gi', require('telescope.builtin').lsp_implementations, '[LSP/T] Go to Implementation')
        set_keymap('go', require('telescope.builtin').lsp_type_definitions, '[LSP/T] Go to Type Definition')
        set_keymap('gr', require('telescope.builtin').lsp_references, '[LSP/T] Go to References')
        set_keymap('gs', vim.lsp.buf.signature_help, '[LSP] Signature Help')
        set_keymap('<F2>', vim.lsp.buf.rename, '[LSP] Rename Symbol')
        set_keymap('<F3>', vim.lsp.buf.format, '[LSP] Format Code')
        set_keymap('<F4>', vim.lsp.buf.code_action, '[LSP] Code Action')
        set_keymap('gl', vim.diagnostic.open_float, '[LSP] Show Diagnostics')
        set_keymap('[d', function() vim.diagnostic.jump({ count = -1 }) end, '[LSP] Previous Diagnostic')
        set_keymap(']d', function() vim.diagnostic.jump({ count = 1 }) end, '[LSP] Next Diagnostic')
        -- stylua: ignore end
      end)

      lsp_zero.set_sign_icons({
        error = "", -- Heavy Ballot X Mark
        warn = "", -- Warning Sign
        hint = "", -- Light Bulb
        info = "", -- Information
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          -- "pyright",
          -- "ruby_lsp",
        },
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,

          require("lspconfig").lua_ls.setup({
            on_init = function(client)
              local path = client.workspace_folders[1].name
              if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                return
              end

              client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                },
              })
            end,
            settings = {
              Lua = {},
            },
          }),

          require("lspconfig").pyright.setup({}),
          require("lspconfig").nil_ls.setup({}),

          -- Custom handlers example
          -- tsserver = function()
          --   require('lspconfig').tsserver.setup({
          --     single_file_support = false,
          --     on_attach = function(client, bufnr)
          --       print('hello tsserver')
          --     end
          --   })
          -- end,

          -- See https://lsp-zero.netlify.app/v3.x/language-server-configuration.html
        },
      })

      require("mason-nvim-dap").setup({
        ensure_installed = {
          -- "python",
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
          --   require('mason-nvim-dap').default_setup(config) -- don't forget this!
          -- end,
        },
      })
    end,
  },
}
