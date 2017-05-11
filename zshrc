# zshrc
# Declares variables and settings useful for any interactive usage of zsh, such
# as prompt, shortcuts, zsh feature settings, etc.

export EDITOR=/usr/local/bin/vim
export CLICOLOR=1
export KEYTIMEOUT=1

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.cargo/bin:$PATH # toying around with Rust a little lately...
export PATH=$HOME/.bin:$PATH
export PATH=$HOME/.bin/local:$PATH

# I haven't needed JAVA_HOME set lately, but this is where it would be declared
# if I decided to enable it.  This is macOS-specific.
# export JAVA_HOME=`/usr/libexec/java_home`

bindkey -v

autoload -U compinit colors

fpath=($HOME/.zsh/completion $fpath)
compinit
colors

setopt complete_in_word
setopt auto_cd

HISTFILE=$HOME/.zsh-histfile
HISTSIZE=5000
SAVEHIST=5000
setopt inc_append_history
setopt share_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_find_no_dups

# configure fuzzy autocomplete on tab
zstyle ':completion:*' matcher-list '' \
'm:{a-z\-}={A-Z\_}' \
'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

source $DOTFILE_HOME/zsh/kjhaber.zsh-theme

precmd () { print -Pn "\e]2;%n@%M | ${PWD##*/}\a" } # title bar prompt

# Last piece of the puzzle for seamlessly switching tmux panes and vim splits
# with ctrl h/j/k/l (vim-tmux-navigator).  Something about vi mode in zsh
# triggers the normal vim word delete command when using ctrl-h.  This defines
# an alternate zle widget and overrides the binding for ctrl-h only when in a
# tmux session.
#
# (BTW, in iTerm2, be sure to map Ctrl-H to send escape sequence [104;5u
# This is CSI code for otherwise terminal will send <BS> key, which won't trigger
# Ctrl-H mappings.  See also https://gitlab.com/gnachman/iterm2/issues/3519 )
function ctrl-h-widget() {
  tmux select-pane -L
}
if [ -n "$TMUX" ]; then
  zle -N ctrl-h-widget
  bindkey '^H' ctrl-h-widget
  bindkey '^[[104;5u' ctrl-h-widget
fi


# From https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
# For fast switching between vim and shell.  Ctrl-Z in vim to put it into
# the background, then Ctrl-Z again to bring it back.
function ctrl-z-widget() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N ctrl-z-widget
bindkey '^Z' ctrl-z-widget

# Prevent accidentally entering zsh command mode (execute-named-cmd) when I hit esc
# (https://superuser.com/questions/928846/what-is-execute-on-the-command-line-and-how-to-i-avoid-it)
bindkey -a -r ':'

# aliases for common typos and jump to favorite directories
alias xeit=exit
alias :q=exit
alias cddesktop="cd $HOME/Desktop"
alias cddocuments="cd $HOME/Documents"
alias cddotfiles="cd $HOME/Library/dotfiles"
alias cdnotes="cd $HOME/Documents/notes"

# cd to git root
alias cdgr='git rev-parse && cd "$(git rev-parse --show-cdup)"'

# Source separate file for environment-specific aliases, as these differ between
# work and home.  I probably still need a better approach for separating my
# environment-specific settings.
source $HOME/.zsh_aliases


# Enable various tools
# thefuck is helpful for autocorrecting typos. I add the 'doh' alias to be a
# shade more polite at my shell; YMMV.
eval "$(thefuck --alias)"
alias doh=fuck

# fasd is meant to make switching between directories more convenient.
eval "$(fasd --init auto)"
alias v='f -e vim' # quick opening files with vim

# nvm is a handy thing when I'm actively working with Node on projects, but it
# slows down shell startup (including new tmux splits/windows) noticeably.
# Leaving it commented out for now, might just add latest nvm version of node
# directly to my path.
export NVM_DIR=$HOME/.nvm
# source "/usr/local/opt/nvm/nvm.sh"


# finally, source all configs in ./zsh/bin/*.zsh
for file in $DOTFILE_HOME/zsh/bin/*.zsh; do
  source "$file"
done

