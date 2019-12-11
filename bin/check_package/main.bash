#!/usr/bin/env bash

DIRECTORY=`dirname $0`

source $DIRECTORY/utils.bash

if [ -f /etc/lsb-release ]; then
  source /etc/lsb-release
fi


function installation() {
  if [ -n "$GPG_PUBLIC_KEYS" ]; then
    echo "gpg2 --recv-keys $GPG_PUBLIC_KEYS"
  fi
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
        if [ -n "$INSTALL_REPOSITORY_URL" ]; then
            if [ -z "$INSTALL_REPOSITORY_DISTRO" ]; then
                INSTALL_REPOSITORY_DISTRO=$(lsb_release -sc)
            fi
	    checkSourceListUpdate
        REPOSITORY_ARCH=""
        if [ -n "$INSTALL_REPOSITORY_ARCH" ]; then
            REPOSITORY_ARCH="[arch=$INSTALL_REPOSITORY_ARCH]"
        fi
            echo "sudo sh -c 'echo \"deb $REPOSITORY_ARCH $INSTALL_REPOSITORY_URL $INSTALL_REPOSITORY_DISTRO $INSTALL_REPOSITORY_COMPONENT\" > /etc/apt/sources.list.d/$INSTALL_NAME.list'"
        unset REPOSITORY_ARCH
	    echo "apt update"
        fi;
    fi

    echo "apt install $PACKAGE_NAME $PACKAGE_NAME_EXTRA"
  fi

  if [ -n "$INSTALL_DOC" ]; then
    echo "$CHAR_BOOK $INSTALL_DOC"
  fi;
}

function checkSourceListUpdate() {
  if [ -n "$INSTALL_REPOSITORY_URL" ]; then
    if [[ "$INSTALL_REPOSITORY_DISTRO" != $(lsb_release -sc) ]] && [[ "$INSTALL_REPOSITORY_DISTRO" != "stable" ]]; then
      RESULT=$(curl -s -o /dev/null -w "%{http_code}" "$INSTALL_REPOSITORY_URL/dists/$(lsb_release -sc)")
      if [ $RESULT -ne 404 ]; then
        echo -e "$(writeOrange $CHAR_WARNING) You can replace $(writeStrike $INSTALL_REPOSITORY_DISTRO) by $(lsb_release -sc)"
      fi
    fi
  fi
}

###
# @param bin
###
function check() {
  if [ -z "$PACKAGE_NAME" ]; then
      PACKAGE_NAME="$INSTALL_NAME";
  fi;

  checkInstalled $INSTALL_NAME

  if [ $? = 0 ]; then
    installed $NAME "$INSTALL_DESCRIPTION"
  else
    uninstalled $NAME "$INSTALL_DESCRIPTION"
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
  unset INSTALL_REPOSITORY_URL;
  unset INSTALL_COMMAND;
  unset PACKAGE_NAME_EXTRA;
  unset INSTALL_PPA;
  unset INSTALL_PACKAGE_REQUIRE;
  unset INSTALL_REPOSITORY_DISTRO;
  unset INSTALL_REPOSITORY_COMPONENT;
  unset GPG_PUBLIC_KEYS;
  unset INSTALL_REPOSITORY_ARCH;
}

writeBold "Package install"

for file in $DIRECTORY/list/*
do
    if [ -f $file ]; then
        NAME=$(basename $file);
        source $file;
        check
        clean_vars;
    fi
done

writeBold "Special install"

for file in $DIRECTORY/special/*
do
    if [ -f $file ]; then
        $file
    fi
done
