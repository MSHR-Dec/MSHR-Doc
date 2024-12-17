#! /bin/bash

DIR=$(cd $(dirname $0); pwd)

mkdir -p ~/.config/nvim/lua
ln -fnsv "${DIR}"/nvim/init.lua ~/.config/nvim/init.sh
ln -fnsv "${DIR}"/nvim/lua/appearances.lua ~/.config/nvim/lua/appearances.lua
ln -fnsv "${DIR}"/nvim/lua/common.lua ~/.config/nvim/lua/common.lua
ln -fnsv "${DIR}"/nvim/lua/plugins.lua ~/.config/nvim/lua/plugins.lua
ln -fnsv "${DIR}"/nvim/lua/tig.lua ~/.config/nvim/lua/tig.lua
ln -fnsv "${DIR}"/nvim/lua/tools.lua ~/.config/nvim/lua/tools.lua
ln -fnsv "${DIR}"/nvim/lua/lsps.lua ~/.config/nvim/lua/lsps.lua

ln -fnsv "${DIR}"/.vimrc ~/.vimrc

mkdir -p ~/.znap/plugins
ln -fnsv "${DIR}"/.zshrc ~/.zshrc

ln -fnsv "${DIR}"/.hyper.js ~/.hyper.js
