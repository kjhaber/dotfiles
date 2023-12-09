# Testing dotfiles and configs in container

This directory contains resources for testing config installation in a Debian Linux container.

To use:
* If not already installed, install podman e.g. `brew install podman` on Mac.
  - Initialize and start podman by running `podman machine init --now` to run a linux VM to host containers.
  - If podman is already installed, run `podman machine start` if it isn't already running.
* `cd` to this directory: `cd ~/.config/meta/testing`
* Run `./run-container.sh` to build a container image from the Containerfile, create a container from the image, start running the container and attach to it in the current shell.  After those processes complete, the window should display a message about the Z Shell configuration function for new users, prompting to create the base zsh config files.
* Press `q` to "Quit and do nothing."  The cursor will appear at a prompt, and you can start testing setup.
* To confirm it's working:
  - Run `whoami` to see current user is "tester"
  - Run `pwd` to see current directory is "/"
  - Run `cd` then `pwd` again to see current directory is now `/home/tester`

You're now ready to test config installation, or whatever else you like, within a fresh Debian Linux container.

When done, run `exit` to close the container shell process and return to your initial shell session.

