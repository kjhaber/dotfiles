# nvm (https://github.com/creationix/nvm) is a handy thing when I'm actively
# working with Node on projects, but it slows down shell startup (including new 
# tmux splits/windows) noticeably.  Using lazy init to minimize this drawback.
#
# Approach is from
# https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/d5ib9fs/
# by way of http://broken-by.me/lazy-load-nvm/

declare -a NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)

NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")

export NVM_DIR=~/.nvm
load_nvm () {
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

for cmd in "${NODE_GLOBALS[@]}"; do
  eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
done

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
