return {
	"jpalardy/vim-slime",
	config = function()
		vim.g.slime_target = "tmux"
		vim.g.slime_default_config = {
			socket_name = "default",
			target_pane = "{right-of}", -- Send to right pane
		}
	end,
}
