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
      handlers = {},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
				root_dir = lspconfig.util.root_pattern("package.json"),
			})
			--lspconfig.omnisharp.setup({
			--	capabilities = capabilities,
			--	enable_roslyn_analyzers = true,
			--	enable_import_completion = true,
			--	organize_imports_on_format = true,
			--	enable_decompilation_support = true,
			--	cmd = { "omnisharp", "-z", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
			--	filetypes = { "cs", "vb", "csx" },
			--})
			lspconfig.powershell_es.setup({
				capabilities = capabilities,
				bundle_path = "~/.local/share/nvim/mason/packages/powershell-editor-services/",
				settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
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
			--vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "go to definition" })
			--vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "go to implementation" })
			--vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "go to references" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "rename" })
			vim.keymap.set("n", "]]", vim.diagnostic.goto_next, { desc = "next diagnostic" })
			vim.keymap.set("n", "[[", vim.diagnostic.goto_prev, { desc = "prev diagnostic" })
		end,
	},
}
