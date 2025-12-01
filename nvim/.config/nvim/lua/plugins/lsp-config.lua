return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
			automatic_enable = {
				exclude = {
					"powershell_es",
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			vim.lsp.config("powershell_es", {
				bundle_path = vim.fn.expand("~/.local/share/nvim/mason/packages/powershell-editor-services/"),
				settings = {
					powershell = {
						codeFormatting = {
							Preset = "OTBS",
							UseCorrectCasing = true,
							AutoCorrectAliases = true,
						},
					},
				},
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})
			vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "diagnostic line" })
			vim.keymap.set("n", "<leader>dc", function()
				local msg = ""
				local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
				if #diagnostics > 0 then
					msg = diagnostics[1].message
					vim.fn.setreg("+", msg)
					vim.notify("Diagnostic message copied to clipboard", vim.log.levels.INFO)
				else
					vim.notify("No diagnostic message on this line", vim.log.levels.WARN)
				end
			end, { desc = "copy diagnostic line message" })
			vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "hover" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "rename" })
			vim.keymap.set("n", "]]", vim.diagnostic.goto_next, { desc = "next diagnostic" })
			vim.keymap.set("n", "[[", vim.diagnostic.goto_prev, { desc = "prev diagnostic" })
		end,
	},
}
