# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//     '\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

prompt_command () {
    if [ $? -eq 0 ]; then # set an error string for the prompt, if applicable
        ERRPROMPT=" "
    else
        ERRPROMPT='->($?) '
    fi
    if [ "\$(type -t __git_ps1)" ]; then # if we're in a Git repo, show current branch
        BRANCH="\$(__git_ps1 '[ %s ] ')"
    fi
    local TIME=`fmt_time` # format time for prompt string
    local LOAD=`cat /proc/loadavg | awk '{print $1}'`
    local GREEN="\[\033[1;32m\]"
    local CYAN="\[\033[1;36m\]"
    local BCYAN="\[\033[1;36m\]"
    local BLUE="\[\033[1;34m\]"
    local GRAY="\[\033[0;37m\]"
    local DKGRAY="\[\033[1;30m\]"
    local WHITE="\[\033[1;37m\]"
    local RED="\[\033[1;31m\]"
    local NC='\e[0m'
    # return color to Terminal setting for text color
    local DEFAULT="\[\033[0;39m\]"

    if [ $(id -u) -eq 0 ];
    then
      export PS1="┌${RED}[\u]${NC} (${LOAD}) ${WHITE}${TIME}${NC} [\h]$ps1_informer:\[\e[0;32;49m\]\w\[\e[0m \n└>"
    else
      export PS1="┌[${GREEN}\u${NC}] (${LOAD}) ${WHITE}${TIME}${NC} [\h]$ps1_informer:\[\e[0;32;49m\]\w\[\e[0m \n└${BRANCH}>"
    fi

}
PROMPT_COMMAND=prompt_command

fmt_time () {
    date +"%H:%M:%S"
}
pwdtail () { #returns the last 2 fields of the working directory
    pwd|awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}
chkload () { #gets the current 1m avg CPU load
    local CURRLOAD=`cat /proc/loadavg | awk '{print $1}'`
    if [ "$CURRLOAD" > "1" ]; then
        local OUTP="HIGH"
    elif [ "$CURRLOAD" < "1" ]; then
        local OUTP="NORMAL"
    else
        local OUTP="UNKNOWN"
    fi
    echo $CURRLOAD
}
