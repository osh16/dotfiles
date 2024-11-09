return {
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
          -- Þetta er viðbjóður
					--null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.clang_format,
				},
			})
			vim.keymap.set("n", "<leader>fd", vim.lsp.buf.format, {})
		end,
	},
	{
		{
			"vidocqh/auto-indent.nvim",
			opts = {},
		},
	},
}
