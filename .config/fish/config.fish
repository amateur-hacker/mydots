#  _____ _     _
# |  ___(_)___| |__
# | |_  | / __| '_ \
# |  _| | \__ \ | | |
# |_|   |_|___/_| |_|
#

# Disable default fish greeting
set fish_greeting

# Setup vi mode keybindings and configure defaults
function fish_user_key_bindings
    fish_vi_key_bindings
    bind yy fish_clipboard_copy
    bind Y fish_clipboard_copy
    bind p fish_clipboard_paste
    bind -M visual -m default y 'fish_clipboard_copy; commandline -f end-selection repaint-mode'
    # bind -M insert -m default jk 'commandline -f repaint'
    bind --erase --preset -M visual \ev
    bind --erase --preset -M insert \ev
    bind \eh backward-word
    bind \ej down-line-or-history
    bind \ek up-line-or-history
    bind \el forward-word
end

# Support for !! and !$
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -M insert ! __history_previous_command
    bind -M insert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Custom keybindings
function peekr_dispatch_semicolon
    if test -z (commandline)
        set -l k (read -l -z -n 1)
        switch $k
            case c
                peekr_search_configs
            case s
                peekr_search_scripts
            case f
                peekr_search_files_cwd
            case F
                peekr_search_nested_files_cwd
            case d
                peekr_select_dir_cwd
            case D
                peekr_select_nested_dir_cwd
            case '*'
                commandline ";$k"
        end
    else
        commandline -i ';'
    end
end
bind -M insert \; "peekr_dispatch_semicolon; commandline -f repaint"
bind -M insert \cy "yazi_cd; commandline -f repaint"

# System info on launch if interactive
if status is-interactive
    fastfetch
end

# Shell integrations
starship init fish | source
zoxide init --cmd cd fish | source
fzf --fish | FZF_ALT_C_COMMAND= FZF_CTRL_T_COMMAND= source
