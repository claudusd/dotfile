DIRECTORY=`readlink -f "${BASH_SOURCE[0]}"`
DIRECTORY=`dirname $DIRECTORY`
DIRECTORY="$DIRECTORY/../../../scripts/home"

export PATH="$PATH:$DIRECTORY/bin"

_home_complete() {
    COMMANDS=$(ls "$DIRECTORY/command")
    cur="${COMP_WORDS[COMP_CWORD]}"
    case $COMP_CWORD in
	1)
            COMPREPLY=$COMMANDS
            ;;
    esac
    return 0
}

complete -F _home_complete home
