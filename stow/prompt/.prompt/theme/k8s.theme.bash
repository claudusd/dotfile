function k8s_prompt {
  if which kubectl-ns kubectl-ctx &> /dev/null; then 
    local cluster=$(kubectl ctx -c)
    local namespace=$(kubectl ns -c)
    echo " $RVM_THEME_PROMPT_PREFIX$blue⁙ $green$cluster$bold_white @ $green$namespace$RVM_THEME_PROMPT_PREFIX"
  fi
}