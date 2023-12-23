return {
	"shaunsingh/nord.nvim",
	name = "nord",
	config = function()
		-- Load the Nord color scheme
		vim.cmd("colorscheme nord")

		-- Set background color for Normal and NormalFloat highlight groups
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

		-- Additional configuration for the Nord theme, if any
		-- require("nord").setup({ ... })
	end,
}
