#!/usr/bin/env bash

if [ "$(tmux display-message -p "#{pane_at_left}")" = "1" ]; then
  tmux select-pane -R
elif [ "$(tmux display-message -p "#{pane_at_right}")" = "1" ]; then
  tmux select-pane -L
  tmux resize-pane -Z
fi
