return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure pylint to use .venv python if available
    local function get_python_path()
      local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
      if vim.fn.executable(venv_python) == 1 then return venv_python end
      return "python" -- fallback to system python
    end

    -- Override pylint command to use correct python
    lint.linters.pylint.cmd = get_python_path()
    lint.linters.pylint.args = {
      "-m",
      "pylint",
      "--output-format",
      "text",
      "--msg-template",
      "{path}:{line}:{column}:{C}: [{symbol}] {msg}",
      "--reports",
      "no",
    }

    lint.linters_by_ft = {
      python = { "pylint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    local function file_in_cwd(file_name)
      return vim.fs.find(file_name, {
        upward = true,
        stop = vim.loop.cwd():match("(.+)/"),
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
        type = "file",
      })[1]
    end

    local function remove_linter(linters, linter_name)
      for k, v in pairs(linters) do
        if v == linter_name then
          linters[k] = nil
          break
        end
      end
    end

    local function linter_in_linters(linters, linter_name)
      for k, v in pairs(linters) do
        if v == linter_name then return true end
      end
      return false
    end

    local function remove_linter_if_missing_config_file(linters, linter_name, config_file_name)
      if linter_in_linters(linters, linter_name) and not file_in_cwd(config_file_name) then
        remove_linter(linters, linter_name)
      end
    end

    local function try_linting()
      local linters = lint.linters_by_ft[vim.bo.filetype]

      -- Conditionally disable linters if their config files are missing.
      -- This prevents noisy linting errors in projects that don't use specific linters.
      -- Uncomment to only run linters when their config files exist in the project.
      if linters then
        -- remove_linter_if_missing_config_file(linters, "eslint_d", ".eslintrc.cjs")
        remove_linter_if_missing_config_file(linters, "eslint_d", "eslint.config.js")
      end

      lint.try_lint(linters)
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function() try_linting() end,
    })

    vim.keymap.set("n", "<leader>l", function() try_linting() end, { desc = "Trigger linting for current file" })
  end,
}
