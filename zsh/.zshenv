export TERM="xterm-256color"
export EDITOR="nvim"
export VISUAL="nvim"

# Env variables fyrir vinnuna
# Hundsum allar færslur sem byrja á #
if [[ -s "$HOME/work/scripts/.env" ]]; then
  export $(grep -v '^#' "$HOME/work/scripts/.env" | xargs)
fi

# WSL drasl
if [[ "$(uname -a | grep -E "[Mm]icrosoft")" ]]; then
  export DISPLAY="$(awk '/nameserver/ { print $2 }' < /etc/resolv.conf)"
  export LIBGL_ALWAYS_INDIRECT=1
  export PROMPT="[%F{yellow}%n%f@%F{yellow}%m%f: %~]%# "
  export BROWSER=/usr/bin/wslview
fi

export NVM_DIR="$HOME/.nvm"
# Defer NVM loading - only initialize when 'nvm' or 'node' commands are first used
export PATH="$NVM_DIR/versions/node/*/bin:$PATH"
export ZK_NOTEBOOK_DIR="$HOME/notes"
export DOTNET_ROOT="$(asdf where dotnet-core 2>/dev/null || asdf where dotnet 2>/dev/null || dirname $(command -v dotnet))"

# path - avoid duplicates by checking if already in PATH
typeset -U PATH path

for dir in "$HOME/.local/share/nvim/mason/bin" "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" "$HOME/.dotnet/tools" "$HOME/.local/bin" "$HOME/work/scripts" "$HOME/.opencode/bin"; do
  [[ ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
done

# fpath
typeset -U FPATH fpath
for dir in "${ASDF_DATA_DIR:-$HOME/.asdf}/completions" "/home/oskar/.zsh/completions"; do
  [[ ":$FPATH:" != *":$dir:"* ]] && fpath=("$dir" $fpath)
done

# sources
if [[ -s "$HOME/.deno/env" ]]; then
  . "/$HOME/.deno/env"
fi

if [[ -s "$HOME/.env" ]]; then
  source "$HOME/.env"
fi
