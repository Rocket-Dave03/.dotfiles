function is_venv --description "Check is provided dir is a python virtual environement" --argument path
	test -f $path/bin/activate.fish && test -e $path/bin/activate.fish
	return $status
end

function check_venv --description "Check if a dir is a/is in a python virtual environement" --argument check_path
	set -f path "$(realpath $check_path/..)"
	if test "$path" != "/"
		is_venv $check_path || check_venv $path
	else
		is_venv $check_path
	end
	return $status
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

if status is-interactive
	hyfetch -b fastfetch
	alias ls "exa --group-directories-first --icons=auto"
	alias rm "trash"

	abbr -a -- lsg 'ls -la --git --git-ignore'

	starship init fish | source



	function activate_venv --on-variable PWD --description 'Activate python venvs on cd'
		status --is-command-substitution; and return
		if check_venv .
			if read_confirm "Activate venv in $PWD"
				source ./bin/activate.fish
			end
		else if test -n "$VIRTUAL_ENV"
			echo "Leaving venv $VIRTUAL_ENV"
			deactivate
		end
		
	end
end

set -x EDITOR nvim
