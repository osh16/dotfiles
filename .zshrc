autoload -U colors && colors	# Load colors
PS1="%B[%{$fg[yellow]%}%n@%{$fg[yellow]%}%M %{$reset_color%}%~%B]%{$reset_color%}$%b "

export TERM="xterm-256color"
export EDITOR="nvim"
export VISUAL="nvim"

# Start the tmux session if not alraedy in the tmux session
if [[ ! -n $TMUX  ]]; then
  "$HOME/.local/bin/tmux-launcher.sh"
fi

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

setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# history
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

source ~/.zsh_aliases

# Basic auto/tab complete:
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# Bætum við .NET completion
function _dotnet_zsh_complete() {
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}
compdef _dotnet_zsh_complete dotnet

# Bætum Mason binaries við í PATH
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# Bætum NVIM vip í PATH
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
