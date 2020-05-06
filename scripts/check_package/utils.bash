#!/usr/bin/env bash

CHAR_OK=' ✓'
CHAR_KO=' ✗'
CHAR_WARNING=' ⚠'
CHAR_BOOK=' 📖'
CHAR_STUDENT=' '

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
  echo -e " $(writeGreen ${CHAR_OK}) $(writeBold ${1})  -  $2"
}

uninstalled() {
  echo -e " $(writeRed ${CHAR_KO}) $(writeBold ${1})  -  $2";
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

githubLatestRelease() {
  RESULT=$(curl -f -u "$GITHUB_AUTH" https://api.github.com/repos/$1/releases/latest 2> /dev/null)
  if [ $? -ne 0 ]; then
    RESULT=$(curl -f -u "$GITHUB_AUTH" https://api.github.com/repos/$1/tags 2> /dev/null)
    if [ $? -ne 0 ]; then 
      echo ""
      return
    fi;
    VERSION=$(echo $RESULT | jq -r .[0].name)
    echo $(extractVersion $VERSION)
    return
  fi
  VERSION=$(echo $RESULT | jq -r '.tag_name')
  echo $(extractVersion $VERSION)
}

pipLatestRelease() {
  RESULT=$(curl -f https://pypi.org/pypi/$1/json 2> /dev/null)
  echo $RESULT | jq -r '.info.version'
}

getVersion() {
  extractVersion "$($1 --version)"
}

extractVersion() {
  echo $1 | sed -n -E 's/[0-9A-Za-z -]*(([0-9]+\.?)+).*/\1/p'
}

checkNewVersion() {
  checkInstalled $1
  if [ $? = 0 ]; then
    version=$(getVersion $1)
    echo $version | grep "$2" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      return 0
    fi
    return 1
  else
    return 0
  fi;
}

