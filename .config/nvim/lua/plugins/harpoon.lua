return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup()
      local harpoon = require("harpoon")
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set("n", "<c-P>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<c-N>", function() harpoon:list():next() end)
    end
	},

}
