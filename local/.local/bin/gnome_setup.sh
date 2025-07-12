#!/usr/bin/env bash

if [[ ! $(echo $XDG_CURRENT_DESKTOP | grep "GNOME") ]]; then
  echo "Not running GNOME"
  exit 0
fi

add_gnome_shortcut.sh --keybinding='<Super>h' --command='alacritty -e htop' --name='htop'
add_gnome_shortcut.sh --keybinding='<Super>Return' --command='alacritty' --name='terminal'
add_gnome_shortcut.sh --keybinding='<Super>f' --command='nautilus' --name='nautilus'
add_gnome_shortcut.sh --keybinding='<Super>b' --command='chromium' --name='chromium'
add_gnome_shortcut.sh --keybinding='<Super><Shift>b' --command='brave' --name='brave'
add_gnome_shortcut.sh --keybinding='<Control><Alt>equal' --command='alacritty -e bash -c "~/work/scripts/chromium_launcher.sh; sleep 0.0"' --name='chromium launcher'
add_gnome_shortcut.sh --keybinding='<Control><Alt>minus' --command='alacritty -e bash -c "~/work/scripts/chromium_launcher.sh; sleep 0.0"' --name='chromium launcher alt'
add_gnome_shortcut.sh --keybinding='<Super>n' --command='alacritty -e bash -c "cd "$HOME/vimwiki";zk edit --interactive' --name='zk'
add_gnome_shortcut.sh --keybinding='<Super><Shift>h' --command='hamster' --name='hamster'

# Enable workspaces 1-9
gsettings set "org.gnome.mutter" "dynamic-workspaces" false
gsettings set "org.gnome.desktop.wm.preferences" "num-workspaces" 9

# Add workspace shortcuts
for i in {1..9}; do
  gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-$i" "['<Super>$i']" 
  gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-$i" "['<Super><Shift>$i']" 
done

# Built in shortcuts
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
gsettings set org.gnome.settings-daemon.plugins.media-keys calculator "['<Super>c']"

# Remove dash to dock hotkeys if they exist
if [[ $(gsettings list-recursively "org.gnome.shell.extensions.dash-to-dock") ]]; then
  for i in {1..9}; do
    gsettings set "org.gnome.shell.extensions.dash-to-dock" "app-hotkey-$i" "['Disabled']"
    gsettings set "org.gnome.shell.extensions.dash-to-dock" "app-shift-hotkey-$i" "['Disabled']"
    gsettings set "org.gnome.shell.extensions.dash-to-dock" "app-ctrl-hotkey-$i" "['Disabled']"
    gsettings set "org.gnome.shell.keybindings" "switch-to-application-$i" "['Disabled']"
  done
fi



