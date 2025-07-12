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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export ZK_NOTEBOOK_DIR="$HOME/vimwiki"
export DOTNET_ROOT="$(asdf where dotnet-core 2>/dev/null || asdf where dotnet 2>/dev/null || dirname $(command -v dotnet))"

# path
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$HOME/.local/bin:$PATH"

# fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
if [[ ":$FPATH:" != *":/home/oskar/.zsh/completions:"* ]]; then export FPATH="/home/oskar/.zsh/completions:$FPATH"; fi

# sources
. "/$HOME/.deno/env"
