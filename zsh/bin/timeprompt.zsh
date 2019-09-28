BARE_PROMPT="$PROMPT"
timeprompt() {
  export PROMPT="\$(date \"+%H:%M:%S\") $BARE_PROMPT"
}
notimeprompt() {
  export PROMPT="$BARE_PROMPT"
}

