return {
  "rmagatti/auto-session",
  lazy = false,
  config = function()
    if vim.env.NO_AUTOSESSION == "1" then
      return
    end
    if vim.env.ZK_NOTEBOOK_DIR then
      require("auto-session").setup({})
    else
      require("auto-session").setup({
        --post_restore_cmds = { "NvimTreeOpen" }
        post_restore_cmds = { "lua require('snacks').explorer()" },
      })
    end
  end,
}
