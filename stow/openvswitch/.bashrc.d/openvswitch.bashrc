VAGRANT_VERSION=$(ovs-vsctl --version)

if [ $? = 0 ]; then
  
  OPENVSWITCH_BASH_PATH="/usr/share/bash-completion/completions/ovs-vsctl-bashcomp.bash"
  
  if [ -f $OPENVSWITCH_BASH_PATH ]; then
    source $OPENVSWITCH_BASH_PATH
  fi
  unset OPENVSWITCH_BASH_PATH
fi
