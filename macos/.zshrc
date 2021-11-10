PATH="/Users/hjafarli/Library/Android/sdk/platform-tools:$PATH"

bindkey -v

alias gitdiscard='git stash save --keep-index --include-untracked && git stash drop'

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

alias l='ls'
alias c='clear'
alias q='exit'
alias v='vim'
alias e='emacsclient -t'
alias p='pulsemixer'
alias r='ranger'
alias f='fish'

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt EXTENDED_HISTORY

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

export PROMPT_COMMAND="history -a; history -n"

bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/hjafarli/.sdkman"
[[ -s "/Users/hjafarli/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/hjafarli/.sdkman/bin/sdkman-init.sh"

# Add ~/bin to PATH
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

