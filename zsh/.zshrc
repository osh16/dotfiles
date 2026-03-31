autoload -U colors && colors	# Load colors
setopt PROMPT_SUBST
PS1='%B[%{$fg[yellow]%}%n@%{$fg[yellow]%}%M %{$reset_color%}%~%B]%{$reset_color%}$([[ -n $(git rev-parse --show-toplevel 2>/dev/null) ]] && echo " (%{$fg[cyan]%}$(git rev-parse --abbrev-ref HEAD 2>/dev/null)%{$reset_color%})")$ %b '

# Start the tmux session if not already in tmux (run in background)
if [[ ! -n $TMUX ]]; then
  "$HOME/.local/bin/tmux-launcher.sh" &
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

# Basic auto/tab complete (with caching for speed):
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi
autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*' menu select matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
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

# fzf completion (lazy-loaded)
fzf-history-widget-lazy() {
  if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
  fi
  zle fzf-history-widget
}
zle -N fzf-history-widget-lazy
bindkey '^R' fzf-history-widget-lazy
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'

# fman bindað á ctrl+f, geggjað viðmót fyrir man pgaes
fman-launch-widget() {
  fman
  zle reset-prompt
}
zle -N fman-launch-widget
bindkey '^F' fman-launch-widget

# Lazy-load NVM - source it once on first command
_load_nvm_once() {
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  fi
  # Remove the precmd hook after loading
  precmd_functions=("${precmd_functions[@]/_load_nvm_once}")
}

# Add the hook to load NVM before the first prompt
precmd_functions+=(_load_nvm_once)

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

# Azure completion
_az_python_argcomplete() {
    local IFS=$'\013'
    local SUPPRESS_SPACE=0
    if compopt +o nospace 2> /dev/null; then
        SUPPRESS_SPACE=1
    fi
    COMPREPLY=( $(IFS="$IFS" \
                  COMP_LINE="$COMP_LINE" \
                  COMP_POINT="$COMP_POINT" \
                  COMP_TYPE="$COMP_TYPE" \
                  _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
                  _ARGCOMPLETE=1 \
                  _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE \
                  "$1" 8>&1 9>&2 1>/dev/null 2>/dev/null) )
    if [[ $? != 0 ]]; then
        unset COMPREPLY
    elif [[ $SUPPRESS_SPACE == 1 ]] && [[ "$COMPREPLY" =~ [=/:]$ ]]; then
        compopt -o nospace
    fi
}
complete -o nospace -o default -o bashdefault -F _az_python_argcomplete "az"

# Docker completion (lazy-loaded)
_load_docker_completion() {
  if [ -f /usr/share/zsh/site-functions/_docker ]; then
    fpath=(/usr/share/zsh/site-functions $fpath)
    autoload -Uz compinit
  elif command -v docker &>/dev/null; then
    source <(docker completion zsh)
  fi
  unset -f _load_docker_completion
}

# Load docker completion when docker command is first used
docker() {
  _load_docker_completion
  command docker "$@"
}
