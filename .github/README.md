# kjhaber config files

My dotfiles and config files for zsh, nvim, git, tmux, etc.

This repo uses the bare git repository approach from https://www.atlassian.com/git/tutorials/dotfiles (also https://news.ycombinator.com/item?id=11070797 ) to avoid symlinking dotfiles all over my home directory.  My older dotfile repo at https://github.com/kjhaber/dotfiles did it that way and worked well for years, but setup on a new machine has always been a pain point.

One thing that's important to me in my dotfile setup is to allow machine-specific extension points: the core configs need to be easy to reuse on my home machines and work machines, but it needs to allow for machine-specific differences: different aliases and paths, shortcuts and scripts, different git username/email, and so on.


## Setup on new machine
(Work in progress)
```
git clone --bare https://github.com/kjhaber/config $HOME/.config/dotfiles-repo
alias gitdotfile='/usr/local/bin/git --git-dir=$HOME/.config/dotfiles-repo/ --work-tree=$HOME'
cd ~
gitdotfile checkout
gitdotfile config --local status.showUntrackedFiles no
```

## Making changes

Idea is to use `gitdotfile` alias in the place of just `git` in git commands to add, commit, and push changes.  The `gitdotfile` alias still works like regular git, but copes with the repo not being in the regular .git directory in the root directory (which is the home directory in this case).

First time:
```
gitdotfile push --set-upstream origin master
```

Subsequent commits can be pushed with just `gitdotfile push`.

## Dependencies
(This needs a lot more detail.)
Homebrew: https://brew.sh/
* neovim
* tmux
* zsh

... lots of other things too, WIP.

## Local overrides
Machine-specific settings are defined in `~/.config-local`.  Everything here is optional.

### ~/.config-local/bin
This directory in included in $PATH, so add any machine-specific scripts or executables here.

### ~/.config-local/git
Git settings.  

`gitconfig-local`
Sourced by `~/.gitconfig`.  This is a good place to put user.name and user.email settings (e.g. work vs. personal).

### ~/.config-local/ideavim
IntelliJ IDEA settings.

`ideavimrc-local`
Sourced by `~/.ideavimrc`.  On personal machines this is a good place to experiment with new bindings.  On work machines I have mappings for our company-specific IntelliJ plugin, particularly for our internal code searching.

### ~/.config-local/nvim
Neovim settings.

`plugins.vim`
Add machine-specific plugins.  I use [vim-plug](https://github.com/junegunn/vim-plug), so plugin entries should follow this format.  On home machines I experiment with more programming languages and other plugins, but there's no reason to include these at work.

`init-before.vim`
`init-after.vim`
Additional "vimrc" init code for the beginning/end of Neovim's regular `init.vim`.  The `init-after.vim` is more useful since it allows overriding settings in `init.vim`.  I use this on home machine for trying out new mappings, defining extra home-specific vimwiki wikis, and stuff like that.

`snippets/all.snippets`
Machine-specific snippets.  I use [vim-snippets](https://github.com/honza/vim-snippets) and [coc.nvim](https://github.com/neoclide/coc.nvim) occasionally.  Snippets here should follow that syntax.

### ~/.config-local/zsh
ZSH settings.

`aliases.zsh`
`path.zsh`
`plugins.zsh`
Aliases, PATH entries, and zsh plugins specific to the machine.  These are sourced by `~.zshrc`, and they could contain arbitrary zsh commands - the separation into separate files is just for organization.  For zsh plugin manager I use [zcomet](https://zcomet.io/).  (For a long time I happily used [Antibody](http://getantibody.github.io/).  When I learned it was deprecated I tried a few other zsh plugin managers.  zcomet gave me the fewest problems.)

`zshenv-before.zsh`
`zshenv-after.zsh`
`zshrc-before.zsh`
`zshrc-after.zsh`
Additional zsh init code for the beginning/end of ZSH's regular `.zshenv` and `.zshrc` configs.  I don't use these much, but they come in handy once in a while.  One example is for setting environment variables for tools that are specific to either work or home.  For example, I set `GRAALVM_HOME` in `zshenv-after.zsh` for messing with [GraalVM](https://www.graalvm.org/) on a personal project.

`autoload/*.zsh`
Additional zsh scripts that should be executed.  This one's more for completeness and consistency with the main `.config/zsh/autoload` scripts, which is where I keep zsh scripts that I don't think are ready to be made into full-blown zsh plugins (or worth the work to do so).

## License
MIT license

