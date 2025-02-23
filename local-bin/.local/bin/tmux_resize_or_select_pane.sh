#!/usr/bin/env bash

# Þetta er basic virkni til að toggla hægra pane
# Hægra pane er eiginlega alltaf notað sem terminal, og vinstra pane textaritill
# 1. Ef við erum í vinstra pane, togglum hægra pane
# 2. Ef við erum í hægra pane, færum til vinstri og maxímíserum það

if [ "$(tmux display-message -p "#{pane_at_left}")" = "1" ]; then
  tmux select-pane -R
elif [ "$(tmux display-message -p "#{pane_at_right}")" = "1" ]; then
  tmux select-pane -L
  tmux resize-pane -Z
fi
