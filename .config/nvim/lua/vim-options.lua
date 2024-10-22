local options = {
  swapfile = false,
  clipboard = "unnamedplus",
  number = true,
  relativenumber = true,
  expandtab = true,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  ignorecase = true,
  encoding = "utf-8",
  termguicolors = true,
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
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Movement
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "J", "5j")
vim.keymap.set("n", "K", "5k")

-- Islenskt
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "æ", ":")
vim.keymap.set("n", "Æ", ":")
vim.keymap.set("n", "þ", "/")

-- Tabs
vim.keymap.set("n", "<leader>tn", ":tabnew<cr>")
vim.keymap.set("n", "<leader>tc", ":tabclose<cr>")

-- Search and replace
vim.keymap.set("n", "S", ":%s//g<Left><Left>")

-- Disable q: command history sem ég kveiki alltaf óvart á
vim.keymap.set("n", "q:", "<nop>")

vim.wo.number = true;
