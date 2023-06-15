function k8s_prompt {
  if which kubectl-ns kubectl-ctx &> /dev/null; then 
    if ! kubectl ctx -c &> /dev/null; then
      return
    fi
    local cluster=$(kubectl ctx -c &2> /dev/null)
    if [ $? -ne 0 ]; then
      return
    fi
    local namespace=$(kubectl ns -c)
    echo " $RVM_THEME_PROMPT_PREFIX$blue⁙ $green$cluster$bold_white @ $green$namespace$RVM_THEME_PROMPT_PREFIX"
  fi
}