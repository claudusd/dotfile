#!/usr/bin/env bash

CHAR_OK=' ✓'
CHAR_KO=' ✗'

if [ -f /etc/lsb-release ]; then
  source /etc/lsb-release
fi

function installed() {
  echo "$CHAR_OK $INSTALL_NAME  -  $INSTALL_DESCRIPTION";
}

function uninstalled() {
  echo "$CHAR_KO $INSTALL_NAME  -  $INSTALL_DESCRIPTION";
}

function checkInstalled() {
  WHICH_COMMAND="which $INSTALL_NAME"
  $WHICH_COMMAND > /dev/null 2>&1
}


function installation() {
  if [ -n "$INSTALL_URL" ]; then
    echo "Installation page : $INSTALL_URL";
  elif [ -n "$INSTALL_REPOSITORY" ]; then
    if [ -n "$INSTALL_REPOSITORY_KEY" ]; then
      echo "wget -q -O- $INSTALL_REPOSITORY_KEY | sudo apt-key add -"
    fi;
    echo "echo '$INSTALL_REPOSITORY' > /etc/apt/sources.list.d/$INSTALL_NAME.list"
    echo "apt install $PACKAGE_NAME"
  else
      echo "apt install $PACKAGE_NAME"
  fi

  if [ -n "$INSTALL_DOC" ]; then
    echo "Documentation : $INSTALL_DOC"
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
}

DIRECTORY=`dirname $0`

for file in $DIRECTORY/list/*
do
    if [ -f $file ]; then
        source $file;
        check
        clean_vars;
    fi
done
