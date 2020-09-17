#!/usr/bin/env bash

CHAR_OK=' ✓'
CHAR_KO=' ✗'
CHAR_WARNING=' ⚠'
CHAR_BOOK=' 📖'
CHAR_STUDENT=' '
CHAR_PACKAGE=' 📦'
char_DINGBAT=' ❍'

COLOR_RESET='\033[0m'
COLOR_RED='\033[31m'
COLOR_GREEN='\033[32m';
COLOR_ORANGE='\033[33m'

BOLD='\'

checkInstalled() {
  WHICH_COMMAND="which $1"
  $WHICH_COMMAND > /dev/null 2>&1
}

checkAptPackageInstalled() {
  apt list --installed 2>/dev/null | grep "^$1/" > /dev/null
}

writeGreen() {
    echo "${COLOR_GREEN}${1}${COLOR_RESET}"
}

writeRed() {
    echo "${COLOR_RED}${1}${COLOR_RESET}"
}

writeOrange() {
    echo "${COLOR_ORANGE}${1}${COLOR_RESET}"
}

installed() {
  echo -e " $(writeGreen ${CHAR_OK}) $(writeBold ${1}) $(trailling $3 ${#1}) -  $2"
}

trailling() {
  local _SPACE="                             "
  local _DIFF="$(($1-$2))"
  echo "${_SPACE:0:_DIFF}"
}

uninstalled() {
  echo -e " $(writeRed ${CHAR_KO}) $(writeBold ${1}) $(trailling $3 ${#1}) -  $2";
}

newVersionAvailable() {
  echo -e "    $(writeOrange $CHAR_WARNING) You can upgrade $(writeBold $1) from $2 to $(writeUnderline $(extractVersion $3))"
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

writeItalic() {
    echo -e "\033[3m$1\033[0m"
}

githubLatestRelease() {
  RESULT=$(curl -f -u "$GITHUB_AUTH" https://api.github.com/repos/$1/releases/latest 2> /dev/null)
  if [ $? -ne 0 ]; then
    RESULT=$(curl -f -u "$GITHUB_AUTH" https://api.github.com/repos/$1/tags 2> /dev/null)
    if [ $? -ne 0 ]; then 
      echo ""
      return
    fi;
    VERSION=$(echo $RESULT | jq -r .[0].name)
    echo $VERSION
    return
  fi
  $(echo $RESULT | jq -r '.tag_name' | grep 'alpha' &> /dev/null)
  if [ $? -eq 0 ]; then 
    RESULT_2=$(curl -f -u "$GITHUB_AUTH" https://api.github.com/repos/$1/releases 2> /dev/null)
    for row in $(echo "${RESULT_2}" | jq -r '.[] | @base64'); do
      RELEASE_NAME=$(echo ${row} | base64 -di | jq -r .name)
      $(echo $RELEASE_NAME | grep 'alpha' &> /dev/null)
      if [ $? -ne 0 ]; then 
        echo $RELEASE_NAME
        break
      fi      
    done
  else
    VERSION=$(echo $RESULT | jq -r '.tag_name')
    echo $VERSION
  fi
}

pipLatestRelease() {
  RESULT=$(curl -f https://pypi.org/pypi/$1/json 2> /dev/null)
  echo $RESULT | jq -r '.info.version'
}

getVersion() {
  $1 --version 2> /dev/null
  if [ $? -eq 0 ]; then 
    local VERSION=$($1 --version)
    extractVersion $VERSION
    return
  fi
  extractVersion "$($1 version)"
}

extractVersion() {
  echo $1 | sed -nre 's/^[^0-9]*(([0-9]+\.)*[0-9]+).*/\1/p'
}

###
# @paran current version
# @param latest version
###
compareVersion() {
  local CURRENT=$(extractVersion ${1})
  local LATEST=$(extractVersion ${2})
  echo "$CURRENT" | grep "$LATEST" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    return 0
  fi
    return 1
}

pipPathDir() {
  echo "$DOT_FILE_PATH/bin/pip/${1}"
}