#! /bin/bash

DIR=$(cd $(dirname $0); pwd)

CUSTOM="${DIR}"/nvim/lua/custom/requirements.lua
if [ ! -e "${CUSTOM}" ]; then
  cp "${CUSTOM}".template "${CUSTOM}"
fi

mkdir -p ~/.config/nvim/lua/custom
ln -fnsv "${DIR}"/nvim/init.lua ~/.config/nvim/init.lua
ln -fnsv "${DIR}"/nvim/lua/appearances.lua ~/.config/nvim/lua/appearances.lua
ln -fnsv "${DIR}"/nvim/lua/common.lua ~/.config/nvim/lua/common.lua
ln -fnsv "${DIR}"/nvim/lua/plugins.lua ~/.config/nvim/lua/plugins.lua
ln -fnsv "${DIR}"/nvim/lua/tig.lua ~/.config/nvim/lua/tig.lua
ln -fnsv "${DIR}"/nvim/lua/tools.lua ~/.config/nvim/lua/tools.lua
ln -fnsv "${DIR}"/nvim/lua/lsps.lua ~/.config/nvim/lua/lsps.lua
ln -fnsv "${DIR}"/nvim/lua/lspkeymap.lua ~/.config/nvim/lua/lspkeymap.lua
ln -fnsv "${DIR}"/nvim/lua/custom/coc.lua ~/.config/nvim/lua/custom/coc.lua
ln -fnsv "${DIR}"/nvim/lua/custom/requirements.lua ~/.config/nvim/lua/custom/requirements.lua
ln -fnsv "${DIR}"/nvim/lua/custom/ruby.lua ~/.config/nvim/lua/custom/ruby.lua
ln -fnsv "${DIR}"/nvim/lua/custom/go.lua ~/.config/nvim/lua/custom/go.lua

ln -fnsv "${DIR}"/.vimrc ~/.vimrc
ln -fnsv "${DIR}"/.bash_profile ~/.bash_profile

mkdir -p ~/.znap/plugins
ln -fnsv "${DIR}"/.zshrc ~/.zshrc

ln -fnsv "${DIR}"/.hyper.js ~/.hyper.js
