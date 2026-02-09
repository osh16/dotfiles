#!/usr/bin/env bash

if [[ $(lsb_release -a | grep "Ubuntu") ]]; then
  sudo apt install -y git wget curl gcc build-essential unzip tar software-properties-common wl-clipboard 

  # Hipstera forrit
  sudo apt install -y zsh tmux fzf fd-find ripgrep htop neofetch tldr bat stow
  sudo snap install neovim # Apt útgáfan er outdated, virðist vera í tómu tjóni

  # Gnome dót 
  sudo apt install -y gnome-tweaks gnome-browser-connector

  # Annað
  sudo apt install -y python3 python3-venv luarocks gh golang
  sudo snap install -y code postman chromium brave
fi

# Node version manager
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

# Deno
if [[ ! -x "$(command -v deno)" ]]; then
  curl -fsSL https://deno.land/install.sh | sh
fi

# Lazygit
if [[ ! -f $(which lazygit) ]]; then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
  rm lazygit.tar.gz lazygit
fi

# asdf
if [[ ! -f $(which asdf) ]]; then
  ASDF_VERSION=$(curl -s "https://api.github.com/repos/asdf-vm/asdf/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo asdf.tar.gz "https://github.com/asdf-vm/asdf/releases/download/v${ASDF_VERSION}/asdf-v0.18.0-linux-amd64.tar.gz"
  sudo tar -xzf asdf.tar.gz -C /usr/local/bin
  rm asdf.tar.gz

  # Add autocompletion
  mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
fi

# zk
if [[ ! -f $(which zk) ]]; then
  git clone https://github.com/zk-org/zk.git
  cd zk
  make
  sudo mv zk /usr/local/bin
  cd -
  rm -rf zk
fi

# harpoon
if [[ ! -f $(which harpoon) ]]; then
  git clone https://github.com/Chaitanyabsprip/tmux-harpoon.git
  cd tmux-harpoon
  make install
  sudo mv harpoon /usr/local/bin
  cd -
  rm -rf tmux-harpoon
fi
