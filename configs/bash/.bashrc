[[ $- != *i* ]] && return

shopt -s extglob
export TERMINAL=alacritty
set -o vi

cd ~

function get_git_prompt {
  GIT_PROMPT=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')
  if [ ! -z "$GIT_PROMPT" ]; then
    GIT_EMAIL=$(grep -m 1 'email' ~/.gitconfig | cut -f2 -d'=' | tr -d ' ')
    GIT_PROMPT="$GIT_PROMPT $GIT_EMAIL"
  fi
  echo $GIT_PROMPT
}
PS1='[\u@\H \t \w $(get_git_prompt)]\$ '

export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export PAGER=less
export VISUAL=nvim
export EDITOR=nvim
export BROWSER=firefox

export NO_AT_BRIDGE=1

alias watch='watch '
alias ls='ls --color=auto'

alias c='clear'
alias q='exit'

alias deep='echo deep | sudo tee /sys/power/mem_sleep'
alias sus='sudo systemctl suspend && slock'

alias syu='sudo pacman -Syu && sudo rkhunter --propupd'
alias pacref='sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias p='pulsemixer'
alias r='ranger'

alias fw='sudo iptables -vL -t filter'
alias fwnat='sudo iptables -vL -t nat'
alias fw6='sudo ip6tables -vL -t filter'
alias fw6nat='sudo ip6tables -vL -t nat'
alias conn='watch ss -atun'
alias connfd='sudo watch lsof -i -n'
alias trafcap='mkdir -p ~/capture && tshark -P -w ~/capture/cap.pcap'

alias vm='sudo virt-manager --connect qemu:///system --show-domain-console arch-1'
alias vmspicy='spicy -h 127.0.0.1 -p 5900 -f &'

alias alt='sed -i '"'"'s/^set $mod Mod4/set $mod Mod1/'"'"' ~/.config/i3/config'
alias super='sed -i '"'"'s/^set $mod Mod1/set $mod Mod4/'"'"' ~/.config/i3/config'

alias gitdiscard='git stash save --keep-index --include-untracked && git stash drop'

alias brightness='sudo nvim /sys/class/backlight/intel_backlight/brightness'
alias xinv='xcalib -i -a'

alias createnotepads='mkdir -p ~/private && touch ~/private/org && touch ~/private/note && touch ~/private/pad'
alias org='nvim ~/private/org'
alias note='nvim ~/private/note'
alias pad='nvim ~/private/pad'

alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

alias zathurawhite='mv ~/.config/zathura/zathurarc ~/.config/zathura/zathurarc.off'
alias zathurablack='mv ~/.config/zathura/zathurarc.off ~/.config/zathura/zathurarc'

function cdb() {
  if [[ -z "$1" ]]; then
    cd ..
    return
  fi
  pwd
  for i in `seq 1 $1`; do
    cd ..
  done
  pwd
}

function extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)tar xvjf $1 ;;
      *.tar.gz)tar xvzf $1 ;;
      *.tar.xz)tar Jxvf $1 ;;
      *.bz2)bunzip2 $1 ;;
      *.rar)unrar x $1 ;;
      *.gz)gunzip $1 ;;
      *.tar)tar xvf $1 ;;
      *.tbz2)tar xvjf $1 ;;
      *.tgz)tar xvzf $1 ;;
      *.zip)unzip $1 ;;
      *.Z)uncompress $1 ;;
      *.7z)7z x $1 ;;
      *)echo "Unrecognized extension: '$1'" ;;
    esac
  else
    echo "Not a valid file: '$1'"
  fi
}

function calc() {
  awk "BEGIN {print $* }"
}

function bintohex() {
  printf '%x\n' "$((2#$1))"
}

function runxtimes() {
  number=$1
  shift
  for i in `seq $number`; do
    $@
  done
}

alias cpu-boost-disable='sudo sh -c "echo 0 >> /sys/devices/system/cpu/cpufreq/boost"'
alias cpu-boost-enable='sudo sh -c "echo 1 >> /sys/devices/system/cpu/cpufreq/boost"'
alias battery-limit-85='sudo sh -c "echo 85 >> /sys/class/power_supply/BAT0/charge_control_end_threshold"'

# G14
#alias fan-silent='sudo sh -c "echo 2 >> /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy"'
#alias fan-turbo='sudo sh -c "echo 1 >> /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy"'
#alias fan-performance='sudo sh -c "echo 0 >> /sys/devices/platform/asus-nb-wmi/throttle_thermal_policy"'
#alias brightness-full='sudo sh -c "echo 255 >> /sys/class/backlight/amdgpu_bl1/brightness"'
#alias brightness-mid='sudo sh -c "echo 150 >> /sys/class/backlight/amdgpu_bl1/brightness"'
#alias brightness-half='sudo sh -c "echo 120 >> /sys/class/backlight/amdgpu_bl1/brightness"'
