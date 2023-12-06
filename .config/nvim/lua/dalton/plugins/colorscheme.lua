return {
	-- "bluz71/vim-nightfly-guicolors",
	-- priority = 1000,
	-- config = function()
	-- 	vim.cmd([[colorscheme nightfly]])
	-- end,

	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").setup({
			--variant = "moon"
		})
		vim.cmd("colorscheme rose-pine")
	end,
}
