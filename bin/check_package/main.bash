#!/usr/bin/env bash

CHAR_OK=' ✓'
CHAR_KO=' ✗'

CHAR_BOOK=' 📖'

COLOR_RESET='\033[0m'
COLOR_RED='\033[31m'
COLOR_GREEN='\033[32m';

if [ -f /etc/lsb-release ]; then
  source /etc/lsb-release
fi

function installed() {
  echo -e "${COLOR_GREEN}${CHAR_OK}${COLOR_RESET} ${NAME}  -  $INSTALL_DESCRIPTION";
}

function uninstalled() {
  echo -e "${COLOR_RED}${CHAR_KO}${COLOR_RESET} ${NAME}  -  ${INSTALL_DESCRIPTION}";
}

function checkInstalled() {
  WHICH_COMMAND="which $INSTALL_NAME"
  $WHICH_COMMAND > /dev/null 2>&1
}


function installation() {
  if [ -n "$INSTALL_URL" ]; then
    echo "Installation page : $INSTALL_URL";
  elif [ -n "$INSTALL_COMMAND" ]; then
    echo "$INSTALL_COMMAND"
  elif [ -n "$PACKAGE_NAME" ]; then

    if [ -n "$INSTALL_PACKAGE_REQUIRE" ]; then
        echo "apt install $INSTALL_PACKAGE_REQUIRE"
    fi

    if [ -n "$INSTALL_PPA" ]; then
        echo "add-apt-repository $INSTALL_PPA"
        echo "apt update"
    else
        if [ -n "$INSTALL_REPOSITORY_KEY" ]; then
            echo "wget -q -O- $INSTALL_REPOSITORY_KEY | sudo apt-key add -"
        fi;
        if [ -n "$INSTALL_REPOSITORY" ]; then
            echo "echo '$INSTALL_REPOSITORY' > /etc/apt/sources.list.d/$INSTALL_NAME.list"
        fi;
    fi

    echo "apt install $PACKAGE_NAME $PACKAGE_NAME_EXTRA"
  fi

  if [ -n "$INSTALL_DOC" ]; then
    echo "$CHAR_BOOK $INSTALL_DOC"
  fi;
}

###
# @param bin
###
function check() {
  if [ -z "$PACKAGE_NAME" ]; then
      PACKAGE_NAME="$INSTALL_NAME";
  fi;

  checkInstalled

  if [ $? = 0 ]; then
    installed
  else
    uninstalled
  fi;
  installation
  echo
}

clean_vars() {
  unset INSTALL_NAME;
  unset PACKAGE_NAME;
  unset INSTALL_DESCRIPTION;
  unset INSTALL_URL;
  unset INSTALL_DOC;
  unset INSTALL_REPOSITORY;
  unset INSTALL_COMMAND;
  unset PACKAGE_NAME_EXTRA;
  unset INSTALL_PPA;
  unset INSTALL_PACKAGE_REQUIRE;
}

DIRECTORY=`dirname $0`

for file in $DIRECTORY/list/*
do
    if [ -f $file ]; then
        NAME=$(basename $file);
        source $file;
        check
        clean_vars;
    fi
done
