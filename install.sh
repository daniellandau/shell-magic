#!/bin/bash

etcdir=$(cd $(dirname "$BASH_SOURCE") && pwd)
cd "$etcdir"

install () {
  src="$etcdir/$1"
  target=~/"$2"
  targetdir=$(dirname $target)
  [[ -e "$target" && ! -h "$target" ]] && echo "$target on jo olemassa ja ei ole symbolinen linkki"
  [[ ! -e "$target" && ! -h "$target" ]] && \
    (mkdir -p $targetdir && ln -s "$src" "$target")
}

function plain_install () {
  install "$1" "$1"
}

plain_install .gitconfig
plain_install .gitignore
plain_install .zprofile
plain_install .zshrc
plain_install .zshrc-private
plain_install .profile
plain_install .persistent_history
plain_install .mailrc
plain_install .vimrc
plain_install .tmux.conf
plain_install .todo.cfg
plain_install .toprc
plain_install .spacemacs
plain_install .ssh
plain_install .byobu
plain_install .mongorc.js
plain_install .gdbinit
plain_install .globalrc
plain_install .ctags

install owncloud.cfg .local/share/data/Nextcloud/nextcloud.cfg
install folders .local/share/data/Nextcloud/folders
install mopidy.conf .config/mopidy/mopidy.conf
install autokey .config/autokey
install ocrfeeder .config/ocrfeeder
install QTodoTxt.conf .config/QTodoTxt/QTodoTxt.conf
install fonts .local/share/fonts
install mupen64plus .local/share/mupen64plus

true
