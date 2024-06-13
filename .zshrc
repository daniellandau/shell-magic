# for TRAMP
if [[ $TERM == "dumb" ]]; then
    unsetopt zle && PS1='> '
    return
fi
zmodload zsh/zprof
alias xclip='xclip -selection clipboard'

alias tmp='cat >/dev/null'

export GRML_NO_APT_ALIASES=1

DISABLE_AUTO_UPDATE="true"

# Ubuntu
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &>/dev/null
# Arch
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &>/dev/null
source ~/local/bin/z.sh
#source ~/.zprofile
export PATH=~/.local/bin:~/local/bin:~/local/bin/$(arch):$PATH

zmodload zsh/zle
zmodload zsh/complist
zmodload zsh/zutil

export EDITOR=vim

alias unlock="loginctl unlock-session $(loginctl list-sessions | grep seat | awk '{print $1;}' |tr -d '\n')"
alias lock="loginctl lock-session $(loginctl list-sessions | grep seat | awk '{print $1;}' |tr -d '\n')"
alias pgrep="pgrep -a"
alias dus="du -hs"
alias killjob="kill -9 %1"
alias nodocker="sudo systemctl stop docker"
alias yesdocker="sudo systemctl start docker"
alias nopostgresql="sudo systemctl stop postgresql"
alias yespostgresql="sudo systemctl start postgresql"

alias DUSH='du -hs * | sort -h'
alias -g L="2>&1 | less"
alias -g G="| grep"
alias -g XG='| xargs grep'
alias -g SH="| sort -h"
alias -g JQ='| jq . -C | less -R'
alias -g WC='| wc -l'
alias -g ANS='$($(fc -ln -1))'
ff() {
  bfs . -name $@
}
fext() {
  bfs . -name \*$@
}

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache

alias doit='sudo $(fc -ln -1)'
alias launchit='launch $(fc -ln -1)'

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:cd:*' ignore-parents parent pwd

#alias shot="cd local/src/shotwell"

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
      echo "${fmt_date} | ${command_part}"  >> ~/local/etc/.persistent_history.$(hostname)
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

#export SBT_OPTS="-Xms512M -Xmx6G -Xss1M -XX:+CMSClassUnloadingEnabled "
#export JAVA_OPTS="$SBT_OPTS"
alias ec="emacsclient -c -a ''"


# export ANSIBLE_COW_SELECTION=stegosaurus
export ANSIBLE_NOCOWS=1

function groot {
  cd $(git rev-parse --show-toplevel)
}

function src {
  cd ~/local/src
}
function misc {
  cd ~/local/misc
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

alias -g LATEST='"$(ls -t1 | head -1)"'
alias openlatest='open "$(ls -t1 | head -1)"'
alias cdlatest='cd "$(ls -t1 *| head -1)"'
alias convertlatest='convert "$(ls -t1 *| head -1)"'
alias rsync='rsync --info=progress2'


alias asteroiddate='adb shell "date $(date +%m%d%H%M.%S)"'

function webm2gif {
  ffmpeg -y -i "$1" -vf fps=10,palettegen /tmp/palette.png

  ffmpeg -i "$1" -i /tmp/palette.png -filter_complex \
    "fps=2,paletteuse" "${2:-out.gif}"

  rm /tmp/palette.png
}

function mp42gif {
  webm2gif "$1" "$2"
}

function cleanupgit {
  for b in $(git branch | grep -v -e '*' -e master) ; do git branch -d $b; done
  git remote prune origin
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

function virtual_env_prompt () {
  REPLY=${VIRTUAL_ENV+(${VIRTUAL_ENV:t}) }
}

function wait-for {
  globs=$(eval ls $1)
  cmd=$2
  file=$(echo $globs | head -n1)
  if [[ -z "$3" ]]; then ((sleep 1 && touch $file )&); fi
  while true;
  do
  files=$(echo $globs | tr '\n' ' ')
  eval inotifywait -e CLOSE_WRITE $files | \
    while read l
    do 
      eval $cmd
      date
    done
  done
}

function hazpasswordbeenpwned {
  read PASSWORD
  HASH=$(printf "%s" "$PASSWORD" | sha1sum | cut -d' ' -f1)
  PREFIX=$(echo $HASH | cut -c -5)
  SUFFIX=$(echo $HASH | cut -c 6-)
  curl -s https://api.pwnedpasswords.com/range/$PREFIX \
    | grep -i $SUFFIX
  if [[ $? -eq 0 ]]
  then
    echo "Yes, that many times ---------------^"
  else
    echo "Yay, not pwned!"
  fi
}

function scp {
  echo "Remember that scp is a shit show"
  /usr/bin/scp "$@"
}

function imagetime {
  epoch2time $(identify -verbose $1 | grep comment | cut -d= -f2) -u
}

function testc {
  clang -Wno-implicit-function-declaration "$1" -o "${1%.c}" && "./${1%.c}"
}

function plot {
  gnuplot -e 'plot "'"$1"'"' -p
}

source ~/.zshrc-private
export BAT_THEME=Coldark-Cold
#export BAT_PAGER=
#
zbell_ignore=($EDITOR $PAGER man)
plugins=(git thefuck dirhistory command-not-found zbell)
export ZSH=~/local/etc/oh-my-zsh
HYPHEN_INSENSITIVE=true
source  $ZSH/oh-my-zsh.sh

zle -N dirhistory_zle_dirhistory_back
zle -N dirhistory_zle_dirhistory_future
zle -N dirhistory_zle_dirhistory_up
zle -N dirhistory_zle_dirhistory_down
bindkey "\e[1;7D" dirhistory_zle_dirhistory_back
bindkey "\e[1;7C" dirhistory_zle_dirhistory_future
bindkey "\e[1;7B" dirhistory_zle_dirhistory_down
bindkey "\e[1;7A" dirhistory_zle_dirhistory_up

function shufflechars {
   python3 -c 'import random; import sys; [sys.stdout.write(" ".join([word[0]+"".join(random.sample(word[1:-1], len(word[1:-1])))+word[-1] for word in line.replace("\n","").split(" ")])+"\n") for line in sys.stdin]'
}

function sleepuntil {
  python -c 'import time, sys; from datetime import datetime, timedelta; from dateutil import parser; time.sleep((parser.parse(sys.argv[1]) - datetime.now()).total_seconds())' "$1"
}

source ~/local/etc/grml.zshrc

function percent_nbsp () {
  REPLY="$(printf '%%#\u00A0')"
}

function colorhash() { md5sum | cut -c 1-5 | python3 -c 'import sys, colorsys; v = sys.stdin.read(); v = int(v, 16) / 0xfffff; v = colorsys.hsv_to_rgb(v, 1, 1); v = "".join([f"{int(v*15.99):x}" for v in v]) ; print(v)' | tr -d '\n' }

grml_theme_add_token percent-nbsp -f percent_nbsp
grml_theme_add_token virtual-env -f virtual_env_prompt '%F{magenta}' '%f'
zstyle ':prompt:grml:left:setup' items rc virtual-env change-root \
       user at host path vcs percent-nbsp


# add |otherhost as needed to prevent conflicts
if [[ $(hostname) =~ 'bertie' ]]
then
  zstyle :prompt:grml:left:items:host pre "%F{#$(hostname | md5sum | colorhash)}%B"
else
  zstyle :prompt:grml:left:items:host pre "%F{#$(hostname | colorhash)}%B"
fi
zstyle :prompt:grml:left:items:host post "%f"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $(which mc) mc 

function xxd_diff () {
  meld <(xxd $1) <(xxd $2)
}


my-accept-line () {
  if [[ "$BUFFER" == *" SUDO" ]]; then
    BUFFER="sudo ${BUFFER% SUDO}"
  fi
  if [[ "$BUFFER" == *" DC" ]]; then
    BUFFER="dc -e '${BUFFER% DC} p'"
  fi
  if [[ "$BUFFER" =~ " (a|b)/" ]]; then
    printf "\nImma go ahead and remove git diff induced a/ or b/ from the command"
    BUFFER="$(echo $BUFFER | sed -re 's_(a|b)/__')"
  fi

  zle .accept-line
}
zle -N accept-line my-accept-line

return
