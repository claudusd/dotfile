if which vagrant &> /dev/null; then
  VAGRANT_VERSION=$(vagrant -v)

  if [ $? = 0 ]; then
    VAGRANT_VERSION=${VAGRANT_VERSION:8}
    
    VAGRANT_BASH_PATH="/opt/vagrant/embedded/gems/$VAGRANT_VERSION/gems/vagrant-$VAGRANT_VERSION/contrib/bash/completion.sh"
    
    if [ -f $VAGRANT_BASH_PATH ]; then
      source $VAGRANT_BASH_PATH
    fi
    unset VAGRANT_BASH_PATH
  fi
fi