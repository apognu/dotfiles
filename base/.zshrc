if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export EDITOR=vim
export VISUAL=vim

# History settings
export HISTFILE=~/.histfile
export HISTSIZE=100000
export SAVEHIST=100000
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

bindkey -e

autoload -Uz compinit
compinit

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

# bindkey "^[Oc" forward-word
# bindkey "^[Od" backward-word

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias glog='git log --format="%h%Cgreen%d%Creset %Cblue%an%Creset %C(white)%ad%Creset %s" --graph --all --date="short"'
alias mux='teamocil --here'

prompt apognu

if [ "$TMUX" = "" ]; then tmux && exit; fi

