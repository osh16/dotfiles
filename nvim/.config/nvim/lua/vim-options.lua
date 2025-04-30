local options = {
	swapfile = false,
	clipboard = "unnamedplus",
	number = true,
	--relativenumber = true,
	smartindent = true,
	expandtab = true,
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	ignorecase = true,
	encoding = "utf-8",
	termguicolors = true,
  splitright = true,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.g.mapleader = " "
vim.g.background = "light"

-- Disable netrw fyrir nvim-tree performance
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Navigation
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Movement
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "J", "5j")
vim.keymap.set("n", "K", "5k")
vim.keymap.set("v", "J", "5j")
vim.keymap.set("v", "K", "5k")

-- Islenskt
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "æ", ":")
vim.keymap.set("n", "Æ", ":")
vim.keymap.set("n", "þ", "/")

-- Tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<cr>", { desc = "new tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<cr>", { desc = "close tab" })

-- Search and replace
vim.keymap.set("n", "S", ":%s//g<Left><Left>")

-- Disable q: command history sem ég kveiki alltaf óvart á
vim.keymap.set("n", "q:", "<nop>")

vim.wo.number = true

-- Define mappings only for Lua files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		-- Execute current line in normal mode
		vim.keymap.set("n", "<leader>l", function()
			vim.cmd("lua " .. vim.fn.getline("."))
		end, { buffer = true })

		-- Execute selected lines in Visual mode
		vim.keymap.set("v", "<leader>l", function()
			local lines = vim.fn.getline("'<", "'>")
			local code = table.concat(lines, "\n")
			vim.api.nvim_exec("lua << EOF\n" .. code .. "\nEOF", false)
		end, { buffer = true })
	end,
})

-- Session options 
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
