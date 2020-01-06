# Adds additional directories to PATH asynchronously.
# In this case, finding current Ruby gem directory with `gem environment gemdir`
# takes about 130ms, which would nearly double my current zsh shell startup time
# of 170ms.
#
# Over time I may extend this to include additional paths or async
# initialization (e.g. replace nvm lazy loading with async init).  (Or I may
# find a simpler way to include the Gem dir on my PATH without having to update
# it whenever a new Ruby version is released on Homebrew.  It's a good enough
# excuse to learning async techniques for zsh for now.)

# Requires zsh-async plugin.
# https://github.com/mafredri/zsh-async
async_init
async_start_worker async_paths_worker -n

async_paths_callback() {
  GEM_BIN_DIR="$3/bin"
  export PATH="$PATH:$GEM_BIN_DIR"
}
async_register_callback async_paths_worker async_paths_callback

async_job async_paths_worker gem environment gemdir

