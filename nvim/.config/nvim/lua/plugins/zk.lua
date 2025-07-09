return {
	{
		"zk-org/zk-nvim",
		config = function()
			require("zk").setup({
        picker = "snacks_picker"
			})
      vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = "Zk New Note" })
      vim.keymap.set("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "Zk Find Notes" })
      vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "Zk Tags" })
      vim.keymap.set("v", "<leader>zl", ":'<,'>ZkInsertLink<CR>", { desc = "Zk Insert Link" })
		end,
	},
}
