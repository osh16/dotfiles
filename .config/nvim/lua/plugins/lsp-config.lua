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
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.azure_pipelines_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.bashls.setup({
				capabilities = capabilities,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				settings = {
					typescript = {
						format = {
							baseIndentSize = 2,
							convertTabsToSpaces = true,
							indentSize = 2,
							indentStyle = "Smart",
						},
					},
					javascript = {
						format = {
							baseIndentSize = 2,
							convertTabsToSpaces = true,
							indentSize = 2,
							indentStyle = "Smart",
						},
					},
				},
			})
			lspconfig.yamlls.setup({
				capabilities = capabilities,
			})
			lspconfig.csharp_ls.setup({
				capabilities = capabilities,
			})
			--lspconfig.omnisharp.setup({
			--	capabilities = capabilities,
			--	enable_roslyn_analysers = true,
			--	enable_import_completion = true,
			--	organize_imports_on_format = true,
			--	enable_decompilation_support = true,
			--	filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
			--})
			lspconfig.powershell_es.setup({
				capabilities = capabilities,
				bundle_path = "~/.local/share/nvim/mason/packages/powershell-editor-services/",
				settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
			})
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
			vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { desc = "hover" })
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "go to definition" })
			vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "go to implementation" })
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "go to references" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "rename" })
		end,
	},
}
