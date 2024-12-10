#! /bin/bash

mkdir -p ~/.config/nvim/lua
ln -fnsv "${PWD}"/init.lua ~/.config/nvim/init.sh
ln -fnsv "${PWD}"/lua/appearances.lua ~/.config/nvim/lua/appearances.lua
ln -fnsv "${PWD}"/lua/common.lua ~/.config/nvim/lua/common.lua
ln -fnsv "${PWD}"/lua/plugins.lua ~/.config/nvim/lua/plugins.lua
ln -fnsv "${PWD}"/lua/tig.lua ~/.config/nvim/lua/tig.lua
ln -fnsv "${PWD}"/lua/tools.lua ~/.config/nvim/lua/tools.lua
