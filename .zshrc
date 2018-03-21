alias xclip='xclip -selection clipboard'

alias tmp='cat >/dev/null'

export GRML_NO_APT_ALIASES=1

# Ubuntu
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &>/dev/null
# Arch
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &>/dev/null
source ~/local/bin/z.sh
source ~/local/etc/grml.zshrc
source ~/.zprofile

zmodload zsh/zle
zmodload zsh/complist
zmodload zsh/zutil

alias pgrep="pgrep -a"
alias dus="du -hs"

alias -g L="2>&1 | less"
alias -g G="| grep"
alias -g XG='| xargs grep'
alias -g DBG='SBT_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5556 $SBT_OPTS"'
alias -g SH="| sort -h"
alias -g JQ='| jq . -C | less -R'
alias -g WC='| wc -l'
alias -g ANS='$($(fc -ln -1))'
ff() {
  find . -name $1
}
fext() {
  find . -name \*$1
}

my-accept-line () {
  if [[ "$BUFFER" == *" SUDO" ]]; then
    BUFFER="sudo ${BUFFER% SUDO}"
  fi
  zle .accept-line
}
zle -N accept-line my-accept-line

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:cd:*' ignore-parents parent pwd

alias shot="cd local/src/shotwell"

# http://stackoverflow.com/questions/30249853/save-zsh-history-to-persistent-history
precmd() { # This is a function that will be executed before every prompt
  if [[ -e ~/.zsh_history ]]
  then
    local line_num_last=$(grep -ane '^:' ~/.zsh_history | tail -1 | cut -d':' -f1 | tr -d '\n')
    local date_part="$(gawk "NR == $line_num_last {print;}" ~/.zsh_history | cut -c 3-12)"
    local fmt_date="$(date -d @${date_part} +'%Y-%m-%d %H:%M:%S')"
    local command_part="$(gawk "NR >= $line_num_last {print;}" ~/.zsh_history | sed -re '1s/.{15}//')"
    if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
    then
      echo "${fmt_date} | ${command_part}"  >> ~/.persistent_history
      export PERSISTENT_HISTORY_LAST="$command_part"
    fi
  fi
}

# bindkey -v
#export KEYTIMEOUT=1

# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
#     zle reset-prompt
# }
#
# zle -N zle-line-init
# zle -N zle-keymap-select
#
function mkcd {
  mkdir "$1"
  cd "$1"
}

export HISTSIZE=50000
export SAVEHIST=50000

consumption() { paste <(cat current_now) <(cat voltage_now)  | gawk '{print ($1 * $2) / 1e12; }'; }
tmpdir() { cd $(mktemp -d) }
reverseip() { echo $1 | tr . '\n' | tac | tr '\n' . }

export SBT_OPTS="-Xms512M -Xmx6G -Xss1M -XX:+CMSClassUnloadingEnabled "
export JAVA_OPTS="$SBT_OPTS"
alias ec="emacsclient -c"


# export ANSIBLE_COW_SELECTION=stegosaurus
export ANSIBLE_NOCOWS=1

function groot {
  cd $(git rev-parse --show-toplevel)
}

function src {
  cd ~/local/src
}

function elmblame {
  find src -name \*.elm | xargs -n 1 -P 1 git blame -p --line-porcelain | grep committer\  | sort | uniq  -c | sort -h
}

function fromepoch {
  date -d @$1
}

function noscale { xrandr --output eDP1 --auto --scale 1x1 --output DP1 --auto --scale 1x1 --right-of eDP1 ; }

function scale {
 xrandr --output eDP1 --auto --pos 0x2880 --output DP1 --auto --scale 2x2 --pos 0x0 --fb 5120x5940
 # xrandr --output eDP1 --auto --scale 1x1 --output DP1 --auto --panning 5120x2880+3840+0 --scale 2x2 --right-of eDP1
}

alias openlatest='open "$(ls -t1 *| head -1)"'
alias convertlatest='convert "$(ls -t1 *| head -1)"'


alias asteroiddate='adb shell "date $(date +%m%d%H%M.%S)"'

function webm2gif {
  ffmpeg -y -i "$1" -vf fps=10,palettegen /tmp/palette.png

  ffmpeg -i "$1" -i /tmp/palette.png -filter_complex \
    "fps=10,paletteuse" "${2:-out.gif}"

  rm /tmp/palette.png
}

function mp42gif {
  webm2gif "$1" "$2"
}

function cleanupgit {
  for b in $(git branch | grep -v -e '*' -e master) ; do git branch -d $b; done
  git remote prune origin
}

function reunifiednlp {
  adb shell 'su -c "mount -o remount,rw /system && mv /data/app/com.google.android.gms-1 /system/priv-app"'
}

difftodo() { diff todo.txt $1 | grep '^>' | cut -c 3- | grep -ve '^\s*$' }

flattenpdf() {
  if [[ $# -ne 2 ]]
  then
    echo "WRONG"
    return 1
  fi
  temp=$(mktemp)
  pdftk "$1" generate_fdf output ${temp} 
  pdftk "$1" fill_form ${temp} output "$2" flatten
  rm ${temp} 
}

quoteclip () {
  paste -d ' ' <(while true; do echo '>'; done) <(xclip -out) | head -n $(xclip -out | wc -l)
}

source ~/.zshrc-private
