# zshrc
# Declares variables and settings useful for any interactive usage of zsh, such
# as prompt, shortcuts, zsh feature settings, etc.

export EDITOR=nvim
export CLICOLOR=1
export KEYTIMEOUT=1

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.cargo/bin:$PATH # toying around with Rust a little lately...
export PATH=$DOTFILE_HOME/bin:$PATH
export PATH=$DOTFILE_LOCAL_HOME/bin:$PATH

bindkey -v

autoload -U compinit colors

# Use `<ESC>v` to edit current command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

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

source $DOTFILE_HOME/zsh/kjhaber.zsh-theme

# title bar prompt
precmd () {
  print -Pn "\e]2;%n@%M | ${PWD##*/}\a" # iterm2 window title
  print -Pn "\e]1;${PWD##*/}\a"         # iterm2 tab title
}


# Prevent accidentally entering zsh command mode (execute-named-cmd) when I hit esc
# (https://superuser.com/questions/928846/what-is-execute-on-the-command-line-and-how-to-i-avoid-it)
bindkey -a -r ':'

alias vi=nvim
alias vim=nvim
alias vimdiff='nvim -d'

# aliases for common typos and jump to favorite directories
alias xeit=exit
alias :q=exit

# using dash to go up a directory is same as netrw in vim
alias -- -='cd ..'

alias cddesktop="cd $HOME/Desktop"
alias cddocuments="cd $DOC_DIR"
alias cddotfiles="cd $DOTFILE_HOME"
alias cddotfiles-local="cd $DOTFILE_LOCAL_HOME"
alias cdnotes="cd $DOC_DIR/notes"
alias cdtodo="cd $TODO_DIR"

# cd to git root
alias cdgr='git rev-parse && cd "$(git rev-parse --show-cdup)"'

# quick calculator function
# usage
# http://www.commandlinefu.com/commands/view/2520/define-a-quick-calculator-function#comment
= () {
  echo $(($*))
}

# Source separate file for environment-specific aliases, as these differ between
# work and home.  I probably still need a better approach for separating my
# environment-specific settings.
source $HOME/.zsh_aliases
if [[ -f "$DOTFILE_LOCAL_HOME/zsh_aliases_local" ]] then
  source "$DOTFILE_LOCAL_HOME/zsh_aliases_local"
fi

# Enable various tools
# thefuck is helpful for autocorrecting typos. I add the 'doh' alias to be a
# shade more polite at my shell; YMMV.
eval "$(thefuck --alias)"
alias doh=fuck

# fzf: fuzzy finder, locate files quickly
# - ctrl-t to insert filename in current command,
# - ctrl-r for recent command history)
export FZF_DEFAULT_COMMAND="rg --files --no-ignore --ignore-case --hidden --follow --glob '!{.git,node_modules,vendor,build,dist}/*'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fasd is meant to make switching between directories more convenient.
eval "$(fasd --init auto)"
alias v='f -e vim' # quick opening files with vim

# todo.txt
alias t='/usr/local/bin/todo.sh -a -d "~/.todo.cfg"'
compdef t='todo.sh'

# tmuxinator
if [[ ! -z "$EXT_REPO_DIR" ]]; then
  source "$EXT_REPO_DIR/tmuxinator/completion/tmuxinator.zsh"
fi

# nvm is a handy thing when I'm actively working with Node on projects, but it
# slows down shell startup (including new tmux splits/windows) noticeably.
# Leaving it commented out for now, might just add latest nvm version of node
# directly to my path.
export NVM_DIR=$HOME/.nvm
# source "/usr/local/opt/nvm/nvm.sh"


# finally, load external configs
for file in $DOTFILE_HOME/zsh/bin/*.zsh; do
  source "$file"
done

if [[ -f "/usr/local/bin/antibody" ]]; then
  source <(antibody init)
  antibody bundle < $DOTFILE_HOME/zsh/plugin-list
fi

