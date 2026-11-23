function is_venv --description "Check is provided dir is a python virtual environement" --argument path
	test -f $path/bin/activate.fish && test -e $path/bin/activate.fish
	return $status
end

function get_venv_dir --description "Get the path of the venv we are in, if one exists" --argument check_path
	set -f path "$(realpath -q $check_path)"
	if test "$check_path" = "//.."
		echo ""
	else if is_venv "$path" 
		echo "$path"
	else if is_venv "$path/.venv/"
		echo "$path/.venv/"
	else
		set found_path (get_venv_dir "$path/..")
		echo $found_path
	end
end

function deactivate_venv
	echo "$(set_color red)Deactivating venv ($VIRTUAL_ENV)"
	deactivate
end

function activate_venv --argument VENV
	if read_confirm "Activate venv in $VENV"
		source "$VENV./bin/activate.fish"
	end
end

# From https://stackoverflow.com/questions/16407530/how-to-get-user-confirmation-in-fish-shell
function read_confirm --description 'Ask the user for confirmation' --argument prompt
    if test -z "$prompt"
        set prompt "Continue?"
    end 

    while true
        read -p 'set_color green; echo -n "$prompt [y/N]: "; set_color normal' -l confirm

        switch $confirm
            case Y y 
                return 0
            case '' N n 
                return 1
        end 
    end 
end

function set_java_path --argument-names java_version
    set -x PATH "/usr/lib/jvm/$java_version/bin/:$PATH"
end

function unset_java_version
    for i in (seq (path_count))
        set entry $PATH[$i]
        if test -n $entry
            if test -n "$(get_java_version)"
                if test $entry = (get_java_version)
                    set --erase PATH[$i]
                end
            end
        end
    end
end

function get_java_version
    echo $PATH | string split " " | rg /usr/lib/jvm | rg -v "/usr/lib/jvm/default/bin"
end

function list_available_java_versions
	command ls -1 /usr/lib/jvm | rg -v "default(-runtime)?" | sort -t '-' -k 2 -n --reverse
end

if status is-interactive
	if test ! (set -q SSH_CONNECTION)
		set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
	end
	hyfetch -b fastfetch
	alias ls "exa --group-directories-first --icons=auto"
	alias rm "trash"

	abbr -a -- lsg 'ls -la --git --git-ignore'

	starship init fish | source

	function change_brightness
		if test $XDG_SESSION_TYPE = "x11"
			read -P "Enter Bightness: " val; xrandr | grep -w connected | cut -f '1' -d ' ' | xargs -I "OUTPUT_NAME" xrandr --output OUTPUT_NAME --brightness $val
		end
	end

	function activate_venv_on_cd --on-variable PWD --description 'Activate python venvs on cd'
		status --is-command-substitution; and return
		set -f VENV (get_venv_dir .)
		if test "$VENV" != ""
			if test -n "$VIRTUAL_ENV"
				if test "$(realpath -q \"$VENV\")" != "$(realpath -q \"$VIRTUAL_ENV\")" # Entering a different venv
					echo "Swaping venv from"
					echo "$(realpath -q \"$VIRTUAL_ENV\")"
					echo "to"
					echo "$(realpath -q \"$VENV\")"
					deactivate_venv
					activate_venv "$VENV"
				else
					echo "Same venv ($VENV) ($VIRTUAL_ENV)"
				end
			else
				activate_venv "$VENV"
			end
		else if test -n "$VIRTUAL_ENV"
			if test -z "$VENV"
				deactivate_venv
			end
		end
		
	end
end

set -x EDITOR nvim
