return {
	"rmagatti/auto-session",
	lazy = false,
	config = function()
		require("auto-session").setup({
      --post_restore_cmds = { "NvimTreeOpen" } 
      post_restore_cmds = { "lua require('snacks').explorer()" }
    })
	end,
}
