#!/usr/bin/env bash

DIRECTORY=`dirname $0`

source $DIRECTORY/utils.bash

GITHUB_AUTH="claudusd:$TOKEN_GITHUB_COM"

if [ -f /etc/lsb-release ]; then
  source /etc/lsb-release
fi

function preInstall() {
  echo -e "$(writeUnderline 'Pre install:')"

  for package in $PRE_PACKAGE_NAME
  do
    checkAptPackageInstalled $package
     if [ $? = 0 ]; then
      echo -e " $(writeGreen ${CHAR_OK}) ${package}"
    else
      echo -e " $(writeRed ${CHAR_KO}) apt install ${package}";
    fi;
  done
}

function installation() {
  if [ -f "$DIRECTORY/list/$NAME.post_install" ] || [ -f "$DIRECTORY/list/$NAME.pre_install" ]; then 
    echo -e "$(writeUnderline 'Install:')"
  fi

  if [ -n "$GPG_PUBLIC_KEYS" ]; then
    echo "gpg2 --recv-keys $GPG_PUBLIC_KEYS"
  fi

  if [ -n "$INSTALL_URL" ]; then
    if [ -n "$GITHUB_REPO" ]; then 
      VERSION=$(githubLatestRelease $GITHUB_REPO)
      checkVersionFromGithub $VERSION
      unset VERSION
    fi
    echo "Installation page : $INSTALL_URL";
  elif [ -n "$INSTALL_COMMAND" ]; then
    echo "$INSTALL_COMMAND"
  elif [ -n "$GITHUB_REPO" ]; then
    installationFromGithubRelease
  elif [ -n "$PIP_PACKAGE" ]; then
    installationFromPip
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

  if [ -f "$DIRECTORY/list/$NAME.post_install" ]; then
    echo -e "$(writeUnderline 'Post install:')"
    $DIRECTORY/list/$NAME.post_install
  fi

  if [ -n "$INSTALL_DOC" ]; then
    echo "$CHAR_BOOK $INSTALL_DOC"
  fi;
}

function checkVersionFromGithub() {
  checkNewVersion $INSTALL_NAME $1
  if [ $? -eq 1 ]; then
    CURRENT_VERSION=$(getVersion $INSTALL_NAME)
    echo -e "$(writeOrange $CHAR_WARNING) You can upgrade $(writeBold $INSTALL_NAME) from $CURRENT_VERSION to $(writeUnderline $VERSION)"
    unset CURRENT_VERSION
  fi
}

function installationFromGithubRelease() {
  VERSION=$(githubLatestRelease $GITHUB_REPO)
  checkVersionFromGithub $VERSION
  BIN_PATH="/usr/local/bin/$NAME"
  echo "curl -L 'https://github.com/$GITHUB_REPO/releases/download/$VERSION/$GITHUB_RELEASE_NAME' -o $BIN_PATH"
  echo "chmod +x $BIN_PATH"
  unset BIN_PATH
  unset VERSION
}

function installationFromPip() {
  VERSION=$(pipLatestRelease $PIP_PACKAGE)
  INSTALL_DIR=$DOT_FILE_PATH
  INSTALL_DIR=$(pwd $INSTALL_DIR/../../)
  INSTALL_DIR="$INSTALL_DIR/bin/pip/$NAME"
  echo "python3 -m venv $INSTALL_DIR/.venv"
  echo "$INSTALL_DIR/.venv/bin/pip install $PIP_PACKAGE==$VERSION"
  echo "echo -e '#!/usr/bin/env bash\nDIRECTORY=\`dirname \$0\`\nsource \$DIRECTORY/.venv/bin/activate\n\$DIRECTORY/.venv/bin/$INSTALL_NAME \$@' > $INSTALL_DIR/$INSTALL_NAME"
  echo "chmod +x $INSTALL_DIR/$INSTALL_NAME"
  echo "make dot-$NAME"
  unset INSTALL_DIR
  unset VERSION
}

function checkSourceListUpdate() {
  if [ -n "$INSTALL_REPOSITORY_URL" ]; then
    if [[ "$INSTALL_REPOSITORY_DISTRO" != $(lsb_release -sc) ]] && [[ "$INSTALL_REPOSITORY_DISTRO" != "stable" ]]; then
      RESULT=$(curl -s -o /dev/null -w "%{http_code}" "$INSTALL_REPOSITORY_URL/dists/$(lsb_release -sc)")
      if [ $RESULT -ne 404 ]; then
        echo -e "$(writeOrange $CHAR_WARNING) You can replace $(writeStrike $INSTALL_REPOSITORY_DISTRO) by $(lsb_release -sc)"
        INSTALL_REPOSITORY_DISTRO=$(lsb_release -sc)
      fi
    fi
  fi
}

###
# @param bin
###
function check() {
  if [ -z "$INSTALL_NAME" ]; then
    INSTALL_NAME="$NAME"
  fi

  if [ -z "$PACKAGE_NAME" ]; then
      PACKAGE_NAME="$INSTALL_NAME";
  fi;

  checkInstalled $INSTALL_NAME

  if [ $? = 0 ]; then
    installed $NAME "$INSTALL_DESCRIPTION"
  else
    uninstalled $NAME "$INSTALL_DESCRIPTION"
  fi;
}

clean_vars() {
  unset NAME;
  # Pre Install vars
  unset PRE_PACKAGE_NAME;
  # Install vars
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
  unset GITHUB_REPO;
  unset GITHUB_RELEASE_NAME;
  unset INSTALL_REPOSITORY_KEY;
  unset PIP_PACKAGE;
}

if ! which jq > /dev/null; then
	writeBold "Required package" 
	NAME="jq"
	INSTALL_DESCRIPTION="How read json in bash"
	check
	exit 
fi

if [ -z "$1" ]; then 
  for file in $DIRECTORY/list/*.install
  do
    if [ -f $file ]; then
        NAME=$(basename $file);
        NAME=${NAME%.install}
        source $file;
        check
        clean_vars;
    fi
  done
else
  if [ -f $DIRECTORY/list/$1.install ]; then
    NAME=$1
    source $DIRECTORY/list/$1.install;
    check
    if [ -f "$DIRECTORY/list/$NAME.pre_install" ]; then
      source $DIRECTORY/list/$NAME.pre_install
      preInstall
    fi

    installation
    clean_vars;
  else 
    echo -e "$(writeRed "Cannot found install for ${1}")";
    exit 1
  fi
  
fi

