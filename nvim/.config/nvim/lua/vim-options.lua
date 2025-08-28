local options = {
	swapfile = false,
	clipboard = "unnamedplus",
	number = true,
	relativenumber = true,
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

-- for c#
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})

-- Disable netrw fyrir nvim-tree performance
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Navigation
--vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
--vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
--vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
--vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

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
vim.keymap.set("i", "<C-ð>", "<Esc>")

-- Tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<cr>", { desc = "new tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<cr>", { desc = "close tab" })

-- Disable q: command history sem ég kveiki alltaf óvart á
vim.keymap.set("n", "q:", "<nop>")

vim.wo.number = true

-- Session options 
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
