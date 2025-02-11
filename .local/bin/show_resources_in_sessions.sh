#!/usr/bin/env bash

# Skrifta sem sýnir hvaða processar eru keyrandi í hvaða tmux sessioni

tmux list-panes -a -F '#{pane_pid} #{session_name}' | while read -r pane_pid session_name; do
    echo "~~~ $session_name ~~~"
    pstree -p $pane_pid | sed 's/[^-][^-]*-/| /g'
    echo
done
