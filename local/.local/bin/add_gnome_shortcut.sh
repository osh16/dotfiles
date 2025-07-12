#!/usr/bin/env bash

# Small script which adds a keyboard shortcut to GNOME. 

# Help command
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo "Usage: $(basename $0) [--keybinding=<binding>] [--command=<command>] [--name=<name>]"
  echo "Example: $(basename $0) --keybinding='<Super>h' --command='alacritty -e htop' --name='htop'"
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --keybinding=*) keybinding="${1#*=}"; shift ;;
        --command=*) command="${1#*=}"; shift ;;
        --name=*) name="${1#*=}"; shift ;;
        *) shift ;;
    esac
done

# Check for required arguments
if [[ -z "$keybinding" || -z "$command" || -z "$name" ]]; then
    "$0" --help
    exit 1
fi

n="$(( $(dconf read /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings | grep -o "custom[0-9]\+" | sed 's/custom//' | sort -n | tail -1) + 1))"

dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$n/binding "'$keybinding'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$n/command "'$command'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$n/name "'$name'"

current_list=$(dconf read /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings)
new_entry="'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$n/'"
if [[ "$current_list" == "@as []" || -z "$current_list" ]]; then
    dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "[${new_entry}]"
else
  updated_list="${current_list%]}"
  updated_list="$updated_list, $new_entry]"
  dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings "$updated_list"
fi
