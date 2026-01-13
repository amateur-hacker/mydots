# Default applications
set -x EDITOR nvim
set -x VISUAL nvim
set -x TERMINAL kitty
set -x BROWSER brave

# XDG base directories
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_STATE_HOME "$HOME/.local/state"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_BIN_HOME "$HOME/.local/bin"

# Common user directories
set -x XDG_DOCUMENTS_DIR "$HOME/documents"
set -x XDG_DOWNLOADS_DIR "$HOME/downloads"
set -x XDG_MUSIC_DIR "$HOME/music"
set -x XDG_PICTURES_DIR "$HOME/pictures"
set -x XDG_SCREENSHOTS_DIR "$XDG_PICTURES_DIR/screenshots"
set -x XDG_VIDEOS_DIR "$HOME/videos"

# Include ~/.local/bin and its subdirs in PATH
if test -d "$HOME/.local/bin"
    for dir in $HOME/.local/bin/*
        if test -d "$dir"; and not contains $dir $PATH
            set -gx PATH $PATH $dir
        end
    end
end

# Redirect tool-specific files to XDG paths
set -x LESSHISTFILE "$XDG_DATA_HOME/less_history"
set -x PYTHON_HISTORY "$XDG_DATA_HOME/python/history"
set -x XINITRC "$XDG_CONFIG_HOME/x11/xinitrc"
set -x XPROFILE "$XDG_CONFIG_HOME/x11/xprofile"
set -x XRESOURCES "$XDG_CONFIG_HOME/x11/xresources"
set -x GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
set -x WGETRC "$XDG_CONFIG_HOME/wget/wgetrc"
set -x PYTHONSTARTUP "$XDG_CONFIG_HOME/python/pythonrc"
set -x GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
set -x GOPATH "$XDG_DATA_HOME/go"
set -x GOBIN "$GOPATH/bin"
set -x GOMODCACHE "$XDG_CACHE_HOME/go/mod"
set -x NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -x GRADLE_USER_HOME "$XDG_DATA_HOME/gradle"
set -x NUGET_PACKAGES "$XDG_CACHE_HOME/NuGetPackages"
set -x _JAVA_OPTIONS "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
set -x PARALLEL_HOME "$XDG_CONFIG_HOME/parallel"
set -x FFMPEG_DATADIR "$XDG_CONFIG_HOME/ffmpeg"
set -x WINEPREFIX "$XDG_DATA_HOME/wineprefixes/default"
set -x ZDOTDIR "$XDG_CONFIG_HOME/zsh"
set -x REDISCLI_RCFILE "$XDG_CONFIG_HOME/redis/redisclirc"
set -x REDISCLI_HISTFILE "$XDG_DATA_HOME/redis/rediscli_history"
set -x W3M_DIR "$XDG_STATE_HOME/w3m"
set -x GIT_CONFIG_GLOBAL "$XDG_CONFIG_HOME/git/config"

# Fix Java GUIs on tiling WMs
set -x _JAVA_AWT_WM_NONREPARENTING 1

# Runtime hints for apps/tools
set -x ELECTRON_OZONE_PLATFORM_HINT wayland
set -x NODE_OPTIONS --no-warnings

# Locale configuration
set -x LC_ALL "en_US.UTF-8"

# Personal environment tweaks
set -x MANPAGER "nvim +Man!"
set -x STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship/starship.toml"
set -x ATAC_MAIN_DIR "$XDG_DATA_HOME/share/atac"

# LS_COLORS
set -x LS_COLORS (dircolors -b | sed 's/^LS_COLORS='\''//;s/'\''$//')

# Full name of user
set -x FULLNAME (getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1)

# Current date/time
set -x DATE (date "+%a, %b %e %I:%M %P")

# FZF configuration
# set -x FZF_DEFAULT_OPTS "\
# --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
# --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
# --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
# --color=selected-bg:#45475A \
# --color=border:#313244,label:#CDD6F4 \
# --exact --border --cycle --height 40% --reverse"

# 'Catppuccin Mocha' theme (bat)
set -x BAT_THEME catppuccin-mocha

# Colored less + termcap vars
set -x LESS "R --use-color -Dd+r -Du+b"
set -x LESS_TERMCAP_mb (printf '\e[1;31m')
set -x LESS_TERMCAP_md (printf '\e[1;36m')
set -x LESS_TERMCAP_me (printf '\e[0m')
set -x LESS_TERMCAP_so (printf '\e[01;44;33m')
set -x LESS_TERMCAP_se (printf '\e[0m')
set -x LESS_TERMCAP_us (printf '\e[1;32m')
set -x LESS_TERMCAP_ue (printf '\e[0m')

# Increase memory limit in NODEJS PROJECTS
set -x NODE_OPTIONS "--max-old-space-size=4096"
