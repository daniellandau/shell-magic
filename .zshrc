# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=5000
setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dlandau/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias -g lines='|wc -l'
alias -g DN=/dev/null
alias -g EG='|& egrep'
alias -g EH='|& head'
alias -g EL='|& less'
alias -g ET='|& tail'
alias -g XG='| xargs egrep'


zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

zstyle ':completion:*:cd:*' ignore-parents parent pwd

PATH=$HOME/local/bin:$PATH

alias open=gnome-open
