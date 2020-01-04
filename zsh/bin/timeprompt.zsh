BARE_PROMPT="$PROMPT"
timeprompt() {
  export PROMPT="\$(date \"+%H:%M:%S\") $BARE_PROMPT"
  export REPORTTIME=0
}
notimeprompt() {
  export PROMPT="$BARE_PROMPT"
  unset REPORTTIME
}

