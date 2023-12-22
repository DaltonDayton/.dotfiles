return {
	-- "bluz71/vim-nightfly-guicolors",
	-- priority = 1000,
	-- config = function()
	-- 	vim.cmd([[colorscheme nightfly]])
	-- end,

	--	"rose-pine/neovim",
	--	name = "rose-pine",
	--	config = function()
	--		require("rose-pine").setup({
	--			--variant = "moon"
	--			vim.cmd("colorscheme rose-pine"),
	--			vim.api.nvim_set_hl(0, "Normal", { bg = "none" }),
	--			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }),
	--		})
	--	end,

	"shaunsignh/nord.nvim",
	name = "nord",
	config = function()
		require("nord").setup({
			vim.cmd("colorscheme nord"),
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" }),
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }),
		})
	end,
}
