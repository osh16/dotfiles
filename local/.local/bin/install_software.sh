#!/usr/bin/env bash

if [[ $(lsb_release -a | grep "Ubuntu") ]]; then
  sudo apt install -y git wget curl gcc build-essential unzip tar software-properties-common wl-clipboard 

  # Hipstera forrit
  sudo apt install -y zsh tmux fzf fd-find ripgrep htop neofetch tldr batcat stow
  sudo snap install neovim # Apt útgáfan er outdated, virðist vera í tómu tjóni

  # Gnome dót 
  sudo apt install -y gnome-tweaks gnome-browser-connector

  # Annað
  sudo apt install -y dotnet python3 python3-venv luarocks gh
  sudo snap install -y code postman chromium brave
fi

# Node version manager
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Lazygit
if [[ ! -f $(which lazygit) ]]; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
fi
