# Remap up/down arrows so they iterate only through history commands
# starting with the characters already typed
# (adapted from comment in https://news.ycombinator.com/item?id=47525243)
bindkey "^[[A" history-search-backward # Up
bindkey "^[[B" history-search-forward  # Down
