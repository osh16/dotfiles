#!/usr/bin/env bash

# Get the session IDs
session_ids="$(tmux list-sessions 2>/dev/null)"

# Create new session if no sessions exist
if [[ -z "$session_ids" ]]; then
  selected=$(find ~/code ~/work ~/w_code/ ~/ /home/ ~/work/modern_workpoint ~/.local/share/nvim/vimwiki -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf)
  if [[ -z $selected ]]; then
    exit 0
  fi
  selected_name=$(basename "$selected" | tr . _)
  tmux new-session -s $selected_name -c $selected
  exit 0
fi

# Select from following choices
#   - Attach existing session
#   - Create new session
#   - Start without tmux
create_new_session="Create new session"
choices="${create_new_session}:\n$session_ids:"
choice="$(echo -e "$choices" | fzf --no-multi --preview '' --bind 'ctrl-d:execute(tmux kill-session -t {+})+reload(tmux list-sessions 2>/dev/null)' | cut -d: -f1)"

if echo -e "$session_ids" | grep -q "^$choice"; then
  # Attach existing session
  tmux switch-client -t "$choice"
elif [[ "$choice" = "${create_new_session}" ]]; then
  # Create new session from directory
  selected=$(find ~/code ~/work ~/w_code/ ~/ /home/ ~/work/modern_workpoint ~/.local/share/nvim/vimwiki -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf)
  if [[ -z $selected ]]; then
    exit 0
  fi
  selected_name=$(basename "$selected" | tr . _)
  if ! tmux has-session -t=$selected_name 2>/dev/null; then
    tmux new-session -ds $selected_name -c $selected
  fi
  tmux switch-client -t $selected_name
fi

