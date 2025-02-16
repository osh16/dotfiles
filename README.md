# dotfiles

Hér erum við með dotfiles fyrir zsh, tmux, vim, o.fl. 

## Skriftur

Skriftur eru í _~/.local/bin_. Í _.zsh_aliases_ er vísað í allskonar vinnuskriftur sem eru hýstar á _dev.azure_ en ekki hérna.

| Skrifta | Lýsing | Flýtiskipun |
| ------- | ------ | ----------- |
| apt_search_packages.sh | Leitar af pökkum með _apt-cache search_ og pípar í _fzf_ | acs [string] |
| install_software.sh | Listi af forritum sem ég nota mikið fyrir fresh uppsetningar | |
| show_resources_in_sessions.sh | Skrifta sem sýnir hvaða processar eru að keyra í hvaða tmux sessioni | pres |
| snap_search_packages.sh | Leitar af pökkum með _snap search_ og pípar í _fzf_ | scs [string] |
| tmux_launcher.sh | Birtir valmynd af keyrandi tmux sessionum fyrir þig til að fara í þegar þú kveikir á terminal | Ctrl+A h |
| tmux_sessionizer.sh | Birtir valmynd af mögulegum tmux sessionum til að fíra upp | Ctrl+A f |
| tmux_resize_or_select.sh | Hjálparskrifta til að hoppa á milli tveggja tmux glugga (einn vim og einn terminal) | Ctrl+A ; |
| x11-gnome-do.py | Man ekki, eitthvað sem ég skoðaði til að hjálpa með multi-monitor support |
