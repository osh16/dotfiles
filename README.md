# dotfiles

Hér erum við með dotfiles fyrir zsh, tmux, vim, o.fl. 

## Uppsetning

Skriftan _install_software.sh_ heldur utan um allskonar forrit sem eru notuð.

```bash
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
```

Til að setja allt upp notum við _stow_


```sh
git clone git@github.com:osh16/dotfiles.git
cd ~/dotfiles
stow -vt ~ */
```

## Skriftur

Skriftur eru í _~/.local/bin_. Í _.zsh_aliases_ er vísað í allskonar vinnuskriftur sem eru hýstar á _dev.azure_ en ekki hérna.

| Skrifta | Lýsing | Flýtiskipun |
| ------- | ------ | ----------- |
| apt_search_packages.sh | Leitar af pökkum með _apt-cache search_ og pípar í _fzf_ | acs [string] |
| install_software.sh | Listi af forritum sem ég nota mikið fyrir fresh uppsetningar | |
| show_resources_in_sessions.sh | Skrifta sem sýnir hvaða processar eru að keyra í hvaða tmux sessioni | pres |
| snap_search_packages.sh | Leitar af pökkum með _snap search_ og pípar í _fzf_ | scs [string] |
| tmux_launcher.sh | Birtir valmynd af keyrandi tmux sessionum fyrir þig til að fara í þegar þú kveikir á terminal | Ctrl+A h |
| tmux_resize_or_select.sh | Hjálparskrifta til að hoppa á milli tveggja tmux glugga (einn vim og einn terminal) | Ctrl+A ; |
