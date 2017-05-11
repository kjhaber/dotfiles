# zshenv
# Limit to variables and settings useful for any usage of zsh, including running
# zsh with a script (exclude anything declared for interactive usage).

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=~/.cargo/bin:$PATH # toying around with Rust a little lately...
export PATH=~/.bin:$PATH
export PATH=~/.bin/local:$PATH

export DOTFILE_HOME="~/Library/dotfiles"

# I haven't needed JAVA_HOME set lately, but this is where it would be declared
# if I decided to enable it.  This is macOS-specific.
# export JAVA_HOME=`/usr/libexec/java_home`

# nvm is a handy thing when I'm actively working with Node on projects, but it
# slows down shell startup (including new tmux splits/windows) noticeably.
# Leaving it commented out for now, might just add latest nvm version of node
# directly to my path.
export NVM_DIR=~/.nvm
# . "/usr/local/opt/nvm/nvm.sh"

