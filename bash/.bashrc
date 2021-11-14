# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s extglob

# Vi mode
set -o vi

# Start with working directory at home
cd ~

# History size
export HISTSIZE=10000
export HISTFILESIZE=10000

# Prompts
# Shows Git branch and current Git email from .gitconfig
function get_git_prompt {
    GIT_PROMPT=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')
    if [ ! -z "$GIT_PROMPT" ]; then
        GIT_EMAIL=$(grep -m 1 'email' ~/.gitconfig | cut -f2 -d'=' | tr -d ' ')
        GIT_PROMPT="$GIT_PROMPT $GIT_EMAIL"
    fi
    echo $GIT_PROMPT
}
#PS1='[\u@\h \W $(get_git_prompt)]\$ ' # Shows only basename of current working directory
PS1='[\u@\H \t \w $(get_git_prompt)]\$ ' # Shows time and dirname/basename of current working directory

# Sync history across terminals in real-time
shopt -s histappend
PROMPT_COMMAND="history -a;history -r;$PROMPT_COMMAND"

# POSIX environment variables
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export PAGER=less
export VISUAL=vim
export EDITOR=vim

# XDG defaults
export BROWSER=chromium

# Add ~/bin to PATH
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# Set up lesspipe
export LESSOPEN="|lesspipe.sh %s"

# Set up GOPATH
export GOPATH="/home/user/go" && export PATH=$PATH:$GOPATH/bin

# Add Ruby gems bin directory to PATH
export PATH=$PATH:/home/user/.gem/ruby/2.6.0/bin

# Prevent Docker from adding iptables rules
export DOCKER_OPTS="--iptables=false"

# Turn on font AA for Java applications
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

# "alias --help": A trailing space in VALUE causes the next word to be checked for alias substitution when the alias is expanded.
alias watch='watch '

# Notepads
alias createnotepads='mkdir -p ~/private && touch ~/private/org && touch ~/private/note && touch ~/private/pad'
alias org='vim ~/private/org'
alias note='vim ~/private/note'
alias pad='vim ~/private/pad'

# Random utils
alias todo='grep -r TODO *'
alias weather='curl wttr.in/Baku'
alias magnet2torrent='aria2c -d ./ --bt-metadata-only=true --bt-save-metadata=true --listen-port=6881 `cat torrent.magnet`'
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias cscoperec="find ./ -type f \( -name '*.c' -o -name '*.h' \) > ./cscope.files && cscope -b -q -k"
alias fixpad="sudo modprobe psmouse -r; sudo modprobe psmouse"

# ls aliases
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -l'
alias llh='ls -lh'
alias lsd='ls -d */'

# Shortcut aliases
alias l='ls'
alias c='clear'
alias q='exit'
alias v='vim'
alias e='emacsclient -t'
alias p='pulsemixer'
alias r='ranger'
alias f='fish'
alias sus='sudo systemctl suspend; slock'
alias syu='sudo pacman -Syu && sudo rkhunter --propupd'
alias pacref='sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist'

# Git aliases
function echo_at {
    echo '@'
}
function echo_dot {
    echo '.'
}
alias gitdiscard='git stash save --keep-index --include-untracked && git stash drop'
alias gitcompany='git config --global user.email HJafarli'$(echo_at)'a''z''e''r''c''e''l''l'$(echo_dot)'c''o''m && git config --global user.name "Hikmat Jafarli" && git config --global user.username HJafarli'
alias gitpersonal='git config --global user.email jafarlihi'$(echo_at)'g''m''a''i''l'$(echo_dot)'c''o''m && git config --global user.name "Hikmat Jafarli" && git config --global user.username jafarlihi'
alias gitcensor='git config --global user.email email@gmail.com && git config --global user.name "Name Surname" && git config --global user.username username'

# Network aliases
alias fw='sudo iptables -vL -t filter'
alias fwnat='sudo iptables -vL -t nat'
alias conn='watch ss -atun'
alias connfd='sudo watch lsof -i'
alias trafcap='mkdir -p ~/capture && tshark -P -w ~/capture/cap.pcap'

# i3wm aliases
alias alt='sed -i '"'"'s/^set $mod Mod4/set $mod Mod1/'"'"' ~/.config/i3/config'
alias super='sed -i '"'"'s/^set $mod Mod1/set $mod Mod4/'"'"' ~/.config/i3/config'

# Zathura aliases
alias zathurawhite='mv ~/.config/zathura/zathurarc ~/.config/zathura/zathurarc.off'
alias zathurablack='mv ~/.config/zathura/zathurarc.off ~/.config/zathura/zathurarc'

# Log aliases
alias d20='dmesg | tail -n 20 | ccze -A'
alias d50='dmesg | tail -n 50 | ccze -A'
alias d200='dmesg | tail -n 200 | ccze -A'
alias j20='journalctl | tail -n 20 | ccze -A'
alias j50='journalctl | tail -n 50 | ccze -A'
alias j200='journalctl | tail -n 200 | ccze -A'
alias wd20='watch "dmesg | tail -n 20"'
alias wj20='watch "journalctl | tail -n 20"'

# Screen aliases
alias brightness='sudo vim /sys/class/backlight/intel_backlight/brightness'
alias xhome='xrandr --output DP1 --auto --right-of eDP1'
alias xvgaoff='xrandr --output DP-2 --off'
alias xvgaon='xrandr --output DP-2 --auto'
alias xvgafull='xrandr --output DP-2 --mode 1920x1080'
alias xvgamed='xrandr --output DP-2 --mode 1600x900'
alias xvgalow='xrandr --output DP-2 --mode 1280x800'
alias xedpoff='xrandr --output eDP-1 --off'
alias xedpon='xrandr --output eDP-1 --auto'

# Extract archives
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

# Navigate back from the working directory, one directory at a time, for the number of times given in the first argument
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

# Navigate to the given path and immediately list directory contents
function cdls() {
    cd "$@" && ls;
}

# Use awk as calculator
function calc() {
    awk "BEGIN {print $* }"
}

export PATH=$PATH:/home/user/opt/cross/bin

export TERM=xterm
