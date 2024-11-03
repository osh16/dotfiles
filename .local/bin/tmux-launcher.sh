#!/usr/bin/env bash

# Get the session IDs
session_ids="$(tmux list-sessions)"

# Create new session if no sessions exist
if [[ -z "$session_ids" ]]; then
  tmux new-session
fi

# Select from following choices
#   - Attach existing session
#   - Create new session
#   - Start without tmux
create_new_session="Create new session"
start_without_tmux="Start without tmux"
choices="$session_ids\n${create_new_session}:\n${start_without_tmux}:"
choice="$(echo -e "$choices" | fzf | cut -d: -f1)"

if echo -e "$session_ids" | grep "$choice"; then
  # Attach existing session
  tmux attach-session -t "$choice"
elif [[ "$choice" = "${create_new_session}" ]]; then
  # Create new session
  tmux new-session
elif [[ "$choice" = "${start_without_tmux}" ]]; then
  # Start without tmux
  :
fi
