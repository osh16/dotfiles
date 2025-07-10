autoload -U colors && colors	# Load colors
PS1="%B[%{$fg[yellow]%}%n@%{$fg[yellow]%}%M %{$reset_color%}%~%B]%{$reset_color%}$%b "


# Start the tmux session if not alraedy in the tmux session
if [[ ! -n $TMUX  ]]; then
  "$HOME/.local/bin/tmux-launcher.sh"
fi


# Bætum við auka workspace í Gnome
if [[ $(echo $XDG_CURRENT_DESKTOP | grep "GNOME") ]]; then

  # Fjarlægjum dash-to-dock ruglið
  if [[ $(gsettings list-recursively "org.gnome.shell.extensions.dash-to-dock") ]]; then
    for i in {1..9}; do
      gsettings set "org.gnome.shell.extensions.dash-to-dock" "app-hotkey-$i" "['Disabled']"
      gsettings set "org.gnome.shell.extensions.dash-to-dock" "app-shift-hotkey-$i" "['Disabled']"
      gsettings set "org.gnome.shell.extensions.dash-to-dock" "app-ctrl-hotkey-$i" "['Disabled']"
      gsettings set "org.gnome.shell.keybindings" "switch-to-application-$i" "['Disabled']"
    done
  fi

  # Stillum á að workspaces 1-9 séu til
  gsettings set "org.gnome.mutter" "dynamic-workspaces" false
  gsettings set "org.gnome.desktop.wm.preferences" "num-workspaces" 9

  for i in {1..9}; do
    gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-$i" "['<Super>$i']" 
    gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-$i" "['<Super><Shift>$i']" 
  done
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
autoload -U +X bashcompinit && bashcompinit
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

# fzf completion
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
bindkey '^R' fzf-history-widget

# fman bindað á ctrl+f, geggjað viðmót fyrir man pgaes
fman-launch-widget() {
  fman
  zle reset-prompt
}
zle -N fman-launch-widget
bindkey '^F' fman-launch-widget

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

