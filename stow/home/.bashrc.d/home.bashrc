DIRECTORY=`readlink -f "${BASH_SOURCE[0]}"`
DIRECTORY=`dirname $DIRECTORY`
DIRECTORY="$DIRECTORY/../../../scripts/home/bin"

export PATH="$PATH:$DIRECTORY"
