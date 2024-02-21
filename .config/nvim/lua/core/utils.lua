local M = {}

M.load_config = function()
    require("core.keymaps")
    require("core.options")
    require("core.autocmds")

    local config = require "core.config"
    return config
end

return M
