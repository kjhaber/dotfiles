#!/bin/sh

# Get nvm from homebrew, then use latest node from nvm.  Easier to control node
# version in use.  NVM_DIR is set to ~/.nvm, so ensure it exists.
mkdir -p ~/.nvm
nvm install node
nvm use node

npm install -g csslint
npm install -g eslint
npm install -g http-server
npm install -g instant-markdown-d
npm install -g lesshint
npm install -g sass-lint
npm install -g typescript
npm install -g js-beautify
npm install -g remark-cli
npm install -g stylelint

