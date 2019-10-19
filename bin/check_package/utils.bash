#!/usr/bin/env bash

CHAR_OK=' ✓'
CHAR_KO=' ✗'

CHAR_BOOK=' 📖'

COLOR_RESET='\033[0m'
COLOR_RED='\033[31m'
COLOR_GREEN='\033[32m';

BOLD='\'

checkInstalled() {
  WHICH_COMMAND="which $1"
  $WHICH_COMMAND > /dev/null 2>&1
}

writeGreen() {
    echo "${COLOR_GREEN}${1}${COLOR_RESET}"
}

writeRed() {
    echo "${COLOR_RED}${1}${COLOR_RESET}"
}

installed() {
  echo -e " $(writeGreen ${CHAR_OK}) ${1}  -  $2"
}

uninstalled() {
  echo -e " $(writeRed ${CHAR_KO}) ${1}  -  $2";
}

writeBold() {
    echo -e "\033[1m$1\033[0m"
}

writeStrike() {
    echo -e "\033[9m$1\033[0m"
}

writeUnderline() {
    echo -e "\033[4m$1\033[0m"
}