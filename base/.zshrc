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

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export GOPATH="/home/${USER}/Programming/go"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias glog='git log --format="%h%Cgreen%d%Creset %Cblue%an%Creset %C(white)%ad%Creset %s" --graph --all --date="short"'
alias sshuttle='sshuttle --method=nft'
alias stern='stern --since=1s'

PS1='%F{red}%n%f/%F{green}%m%f %B%3~%b %(?:%F{green}ツ%f:%F{red}✖%f) %# '

[ -z "$TMUX" ] && tmux && exit
