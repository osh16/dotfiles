return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = true,
      window = {
        width = 0.3,
      },
		},
		config = {
			mappings = {
				reset = {
					insert = "",
					normal = "",
				},
			},
		},
    vim.keymap.set("v", "<leader>cct", "<ESC>:CopilotChatOpen<CR>", {desc = "Copilot toggle"}),
    vim.keymap.set("v", "<leader>ccf", "<ESC>:CopilotChatFix<CR>", {desc = "Copilot fix"}),
    vim.keymap.set("v", "<leader>cco", "<ESC>:CopilotChatOptimize<CR>", {desc = "Copilot optimize"}),
    vim.keymap.set("v", "<leader>cce", "<ESC>:CopilotChatExplain<CR>", {desc = "Copilot explain"}),
    vim.keymap.set("n", "<leader>cct", ":CopilotChatToggle<CR>", {desc = "Copilot toggle"}),
    vim.keymap.set("n", "<leader>cce", ":CopilotChatExplain<CR>", {desc = "Copilot explain"}),
    vim.keymap.set("n", "<leader>ccf", ":CopilotChatFix<CR>", {desc = "Copilot fix"}),
    vim.keymap.set("n", "<leader>cco", ":CopilotChatOptimize<CR>", {desc = "Copilot optimize"}),
    vim.keymap.set("n", "<leader>ccr", ":CopilotChatReset<CR>", {desc = "Copilot review"}),
    vim.keymap.set("n", "<leader>ccs", ":CopilotChatStop<CR>", {desc = "Copilot stop"}),
		vim.keymap.set("n", "<leader>ccq", function()
      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
      end
		end, { desc = "Copilot quick chat" }),
	},
}
