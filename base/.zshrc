[ -z "$TMUX" ] && exec tmux && exit

export EDITOR=vim
export VISUAL=vim

# History settings
export HISTFILE=~/.histfile
export HISTSIZE=100000
export SAVEHIST=100000

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

bindkey -e

autoload -Uz compinit
autoload -U select-word-style

compinit
select-word-style bash

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*:*:*:*:*' menu select

source /usr/share/fzf/key-bindings.zsh

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export GOPATH="/home/${USER}/Programming/go"
export PATH="${GOPATH}/bin:${PATH}"

alias glog='git log --format="%h%Cgreen%d%Creset %Cblue%an%Creset %C(white)%ad%Creset %s" --graph --all --date="short"'
alias sshuttle='sshuttle --method=nft'
alias stern='stern --since=1s'
alias cat='bat --style changes,numbers'
alias less='bat --paging always'
alias ls='exa --group-directories-first --git'

PS1='%F{red}%n%f/%F{green}%m%f %B%3~%b %(?:%F{green}ツ%f:%F{red}✖%f) %# '

