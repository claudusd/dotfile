DIRECTORY="$DOT_FILE_PATH/scripts/home"

export PATH="$PATH:$DOT_FILE_PATH/scripts/home/bin"

_home_complete() {
    COMMANDS=$(ls "$DIRECTORY/command")
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    case $COMP_CWORD in
	1)
            COMPREPLY=($(compgen -W "$COMMANDS" -- ${cur}))
            ;;
	2)
	    COMPLETE=$($DIRECTORY/command/$prev -c)
	    COMPREPLY=($(compgen -W "$COMPLETE" -- ${cur}))
            ;;
    esac
    return 0
}

complete -F _home_complete home

