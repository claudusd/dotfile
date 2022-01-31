if [ -d "/usr/local/go" ]; then
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  export GOPATH="$HOME/go"
fi
