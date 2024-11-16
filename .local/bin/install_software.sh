#!/usr/bin/env bash

if [[ $(lsb_release -a | grep "Ubuntu") ]]; then
  # Basic tól 
  sudo apt install -y git wget curl gcc build-essential unzip tar 

  # Hipstera forrit
  sudo apt install -y zsh neovim tmux fzf fd-find ripgrep htop neofetch

  # Gnome dót 
  sudo apt install -y gnome-tweaks gnome-browser-connector

  # Annað
  sudo apt install -y dotnet python3 python3-venv luarocks gh
  sudo snap install -y code postman chromium brave
fi

if [[ ! -d "$HOME/.nvm" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi
