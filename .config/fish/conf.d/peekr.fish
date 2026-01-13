function peekr_generate_paths --description '(Re)generate peekr_paths.fish from TOML config'
    set -l cfg_file "$XDG_CONFIG_HOME/peekr/config.toml"
    set -l output "$XDG_CONFIG_HOME/fish/conf.d/peekr_paths.fish"

    echo "# Auto-generated from $cfg_file" >$output
    echo "" >>$output

    echo "set CONFIG_PATHS \\" >>$output

    for base in (tq -o json CONFIG_PATHS -f $cfg_file | jq -r 'keys[]')
        set -l expanded (string replace -ra '\$HOME' $HOME $base)
        set -l entries (
            tq -o json CONFIG_PATHS -f $cfg_file \
            | jq -r --arg k "$base" '.[$k][]' \
            | string join ' '
        )
        echo "    \"$expanded\" \"$entries\" \\" >>$output
    end
    echo "" >>$output

    echo "set SCRIPT_PATHS \\" >>$output
    for base in (tq -o json SCRIPT_PATHS -f $cfg_file | jq -r 'keys[]')
        set -l expanded (string replace -ra '\$HOME' $HOME $base)
        set -l entries (
            tq -o json SCRIPT_PATHS -f $cfg_file \
            | jq -r --arg k "$base" '.[$k][]' \
            | string join ' '
        )
        echo "    \"$expanded\" \"$entries\" \\" >>$output
    end

    echo (set_color green)"✓ peekr_paths.fish regenerated at $output"(set_color normal)
end

# Helper: Clean and resolve selected paths, then open in editor
function open_selected_files --argument-names header
    set -l selected (
        printf '%s\n' $argv[2..-1] |
        sed "s|$HOME|~|" |
        fzf -m --header="$header" --header-first |
        sed "s|~|$HOME|" |
        sed 's/[*@/]$//'
    )

    test -z "$selected"; and return

    set -l files
    set -l sudo_files

    for filepath in (string split \n $selected)
        test -z "$filepath"; and continue
        set -l resolved (realpath "$filepath" 2>/dev/null)
        if test -w "$resolved"
            set files $files $resolved
        else
            set sudo_files $sudo_files $resolved
        end
    end

    if test (count $files) -gt 0
        eval $EDITOR $files
    end

    if test (count $sudo_files) -gt 0
        sudo -e $sudo_files
    end
end

# Search config files
function peekr_search_configs --description 'fzf pick config(s)'
    set -l file_paths

    for base in (dict keys CONFIG_PATHS)
        set -l entries (string split ' ' (dict get CONFIG_PATHS $base))

        for entry in $entries
            set -l target "$base/$entry"

            if string match -rq '[()|*+?]' -- $entry
                set -l pattern "$target"
                for f in (find $base -regextype posix-extended -type f -regex "$pattern" 2>/dev/null)
                    set file_paths $file_paths $f
                end
            else
                test -e "$target"; or continue
                for f in (find "$target" -type f 2>/dev/null)
                    set file_paths $file_paths $f
                end
            end
        end
    end

    test -n "$file_paths"; and open_selected_files search_configs $file_paths
end

# Search script files
function peekr_search_scripts --description 'fzf pick script(s)'
    set -l file_paths

    for base in (dict keys SCRIPT_PATHS)
        set -l entries (string split ' ' (dict get SCRIPT_PATHS $base))

        for entry in $entries
            set -l target "$base/$entry"

            if string match -rq '[()|*+?]' -- $entry
                set -l pattern "$target"
                for f in (find $base -regextype posix-extended -type f -executable -regex "$pattern" 2>/dev/null)
                    set file_paths $file_paths $f
                end
            else
                test -e "$target"; or continue
                for f in (find "$target" -type f -executable 2>/dev/null)
                    set file_paths $file_paths $f
                end
            end
        end
    end

    test -n "$file_paths"; and open_selected_files search_scripts $file_paths
end

# Search files in current directory
function peekr_search_files_cwd --description 'fzf pick file(s) (cwd)'
    set -l files (
      find . -maxdepth 1 -mindepth 1 \( -type f -o -type l \) \
        | grep -v '/\.git/' \
        | grep -vE '^\./\.\.?$' \
        | sed 's|^\./||' \
        | awk '{print ($0 ~ /^\./ ? "0" : "1") " " $0}' \
        | sort -k1,1 -k2,2f \
        | cut -d' ' -f2-
    )
    open_selected_files search_files_cwd $files
end

# Search nested files
function peekr_search_nested_files_cwd --description 'fzf pick file(s) (nested)'
    set -l files (
      find . \( -type f -o -type l \) \
        | grep -v '/\.git/' \
        | grep -vE '^\./\.\.?$' \
        | sed 's|^\./||' \
        | awk '{print ($0 ~ /^\./ ? "0" : "1") " " $0}' \
        | sort -k1,1 -k2,2f \
        | cut -d' ' -f2-
    )
    open_selected_files search_nested_files_cwd $files
end

# Select directory in current directory
function peekr_select_dir_cwd --description 'fzf cd (cwd)'
    set -l dir (
      find . -maxdepth 1 -mindepth 1 -type d ! -name '.git' \
        | sed 's|^\./||' \
        | awk '{print ($0 ~ /^\./ ? "0" : "1") " " $0}' \
        | sort -k1,1 -k2,2f \
        | cut -d' ' -f2- \
        | fzf --header="select_dir_cwd" --header-first
    )
    test -n "$dir"; and cd "$dir"
end

# Select nested directory
function peekr_select_nested_dir_cwd --description 'fzf cd (nested)'
    set -l dir (
      find . -mindepth 1 -type d ! -name '.git' \
        | sed 's|^\./||' \
        | awk '{print ($0 ~ /^\./ ? "0" : "1") " " $0}' \
        | sort -k1,1 -k2,2f \
        | cut -d' ' -f2- \
        | fzf --header="select_nested_dir_cwd" --header-first
    )
    test -n "$dir"; and cd "$dir"
end
