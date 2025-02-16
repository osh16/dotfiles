return {
  "jpalardy/vim-slime",
  config = function()
    vim.g.slime_target = "tmux"

    -- TODO: fá þetta til að virka
    local function ensure_right_pane()
      local tmux_pane = vim.fn.system("tmux display-message -p '#{pane_at_right}'"):gsub("\n", "")

      if tmux_pane == "0" then
				vim.fn.system("tmux select-pane -R")
      end
    end
    vim.g.slime_default_config = {
      socket_name = "default",
      target_pane = "{right-of}", -- Send to right pane
    }
  end,
}
