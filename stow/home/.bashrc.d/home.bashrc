DIRECTORY=`readlink -f "${BASH_SOURCE[0]}"`
DIRECTORY=`dirname $DIRECTORY`
DIRECTORY="$DIRECTORY/../../../scripts/home"

export PATH="$PATH:$DIRECTORY/bin"

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

