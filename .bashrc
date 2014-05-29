#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='\u@\W\$ '

alias open=gnome-open
shopt -s checkwinsize
source /etc/profile.d/vte.sh

PATH=$HOME/local/bin:$PATH
