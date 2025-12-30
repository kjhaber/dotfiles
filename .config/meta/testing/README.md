# Testing dotfiles and configs in container

This directory contains resources for testing config installation in a Debian Linux container.

## Basic usage
To use:
* If not already installed, install podman e.g. `brew install podman` on Mac.
  - Initialize and start podman by running `podman machine init --now` to run a linux VM to host containers.
  - If podman is already installed, run `podman machine start` if it isn't already running.
* `cd` to this directory: `cd ~/.config/meta/testing`
* Run `./run-container.sh`
  - This script builds a container image from the Containerfile, creates a container from the image, starts running the container, and attaches to it in the current shell.
  - After those processes complete, the terminal should display a message about the Z Shell configuration function for new users, prompting to create the base zsh config files.
* Press `q` to "Quit and do nothing."  The cursor will appear at a prompt, and you can start testing setup.
* To confirm it's working:
  - Run `whoami` to see current user is "tester"
  - Run `pwd` to see current directory is "/"
  - Run `cd` then `pwd` again to see current directory is now `/home/tester`

You're now ready to test config installation, or whatever else you like, within a fresh Debian Linux container.

The "tester" user password is `xx` (e.g. for sudo commands) - this can be found in the Containerfile.

When done, run `exit` to close the container shell process and return to your initial shell session.


## Config testing
1. Run [Homebrew](https://brew.sh/) install script:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
  - This command should be the same for both Mac and Linux
  - Confirm prompts, requires sudo (tester password is "xx")
  - After running, the `brew` command is not on the PATH right away; next steps take care of that.

2. Run the dotfile [install script](https://github.com/kjhaber/dotfiles/blob/main/.config/meta/install/install.sh):
```
curl -fsSL https://github.com/kjhaber/dotfiles/raw/main/.config/meta/install/install.sh | zsh
```
  - This command sets up dotfiles from the git repo
  - It also installs additional software if not present:
    - fzf (fuzzy finder https://github.com/junegunn/fzf )
    - mise (general dev tool version manager https://mise.jdx.dev/ - also installs node and python)
    - tpm (tmux plugin manager https://github.com/tmux-plugins/tpm )
    - tmux plugins
    - zcomet (zsh plugin manager https://github.com/agkozak/zcomet )
    - zsh plugins

3. Start a new shell by running `zsh`.
  - The shell prompt should update: blue arrow (↪) on left, red directory indicator on right

4. Install updated software with brew:
```
brew install neovim tmux ripgrep
```

5. Open neovim by running `nvim` (also aliased to just `vi`).
  - On first run, Lazy.nvim package manager and coc.nvim will launch and install plugins
  - Run `:checkhealth` to make sure the rest of the install is ok

6. Start a tmux session by running `tm example`
  - To install tpm plugins, press the tmux action key (backtick key, not tmux's default ctrl-b) plus <Shift-I>.
  - Easy way to check is to use tmux action key plus "e" to invoke the tmux-editpanecontent plugin, which opens a new tmux panel with an editor to the right.

You can also run the `sup` script ("Software UPdate" at ~/.config/bin/sup) to interactively fetch updates for brew, mise, neovim plugins, zsh plugins and tmux plugins.

