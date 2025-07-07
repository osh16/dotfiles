require("vim-options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
}, {
  change_detection = {
    notify = false,
  },
})


vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Get a list of all buffers
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
      -- Check if the buffer name matches 'copilot-chat'
      if vim.api.nvim_buf_get_name(buf):match("copilot%-chat") then
        -- Delete the buffer
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end,
})
