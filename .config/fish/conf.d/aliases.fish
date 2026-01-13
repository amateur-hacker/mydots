# Directory navigation
alias ..="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias .4="cd ../../../.."
alias .5="cd ../../../../.."

# Common command settings
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vI"
alias bc="bc -ql"
alias qalc="qalc -t"
alias mkdir="mkdir -pv"
alias locate="plocate"
alias trm="trash-put -v"
alias tres="trash-restore"
alias tls="trash-list"
alias tclean="trash-empty"
alias grep='grep --color=always'
alias rg='rg --smart-case --color=always'
alias ln='ln -iv'
alias chmod='chmod -v'
alias chown='chown -v'
alias ls='lsd --icon=always --color=always --group-directories-first'
alias la='lsd -a --icon=always --color=always --group-directories-first'
alias ll='lsd -l --icon=always --color=always --group-directories-first'
alias lla='lsd -al --icon=always --color=always --group-directories-first'
alias lt='lsd -a --tree --icon=always --color=always --group-directories-first'
alias l.='lsd -d --icon=always --color=always --group-directories-first .*'

# Application shortcuts
alias v="nvim"
alias za="zathura"

# Clean home directory
alias wget="wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\""

# Change the default shell
alias tobash="chsh $USER -s /bin/bash && echo 'Log out and log back in to apply changes.'"
alias tozsh="chsh $USER -s /bin/zsh && echo 'Log out and log back in to apply changes.'"
alias tofish="chsh $USER -s /bin/fish && echo 'Log out and log back in to apply changes.'"

# File permissions
alias pxu='chmod -v u+x' # user exec only
alias pxall='chmod -v a+x' # all can execute
alias plock='chmod -Rv u=,g=,o=' # 000
alias prwu='chmod -Rv u=rw,g=r,o=r' # 644
alias prwall='chmod -Rv a=rw' # 666
alias pxpub='chmod -Rv u=rwx,g=rx,o=rx' # 755
alias pfull='chmod -Rv a=rwx' # 777
alias pinfo='eza --no-time --no-user --no-filesize -l'

# File owner and groups
alias own='eza -lg --no-time --no-filesize --no-permissions'

# File Utilities
alias ex="unp" # Extract any archive(s)
alias f="find . | grep" # Search files in the cwd

# Search command line history
alias h="history | grep"

# Disk info
alias diskinfo="dysk --sort type-desc"

# System monitoring
alias p="ps aux | grep"
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Package manager helpers
alias packsi="paru -Slq | fzf --multi --preview 'paru -Sii {1}' --preview-window=down:75% | xargs -ro paru -S" # package search and install
alias packsrm="pacman -Qqe | fzf --multi --preview 'pacman -Qi {1}' --preview-window=down:75% | xargs -ro sudo pacman -Rns" # package search and remove
