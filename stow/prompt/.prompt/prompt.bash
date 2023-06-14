#!/usr/bin/env bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source "${DIR}/theme/colors.theme.bash"
source "${DIR}/theme/base.theme.bash"
source "${DIR}/theme/k8s.theme.bash"

source "${DIR}/theme/bakke.theme.bash"

if [[ $PROMPT ]]; then
    export PS1="\["$PROMPT"\]"
fi
