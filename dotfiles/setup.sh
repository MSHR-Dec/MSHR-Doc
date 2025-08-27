#! /bin/bash

DIR=$(cd $(dirname $0); pwd)

CUSTOM_REQUIREMENT="${DIR}"/nvim/lua/custom/requirements.lua
CUSTOM_LUA="${DIR}"/nvim/lua/custom/custom.lua
if [ ! -e "${CUSTOM_REQUIREMENT}" ]; then
  cp "${CUSTOM_REQUIREMENT}".template "${CUSTOM_REQUIREMENT}"
fi
if [ ! -e "${CUSTOM_LUA}" ]; then
  cp "${CUSTOM_LUA}".template "${CUSTOM_LUA}"
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
ln -fnsv "${DIR}"/nvim/lua/codecompanionstatus.lua ~/.config/nvim/lua/codecompanionstatus.lua
ln -fnsv "${DIR}"/nvim/lua/custom/coc.lua ~/.config/nvim/lua/custom/coc.lua
ln -fnsv "${DIR}"/nvim/lua/custom/requirements.lua ~/.config/nvim/lua/custom/requirements.lua
ln -fnsv "${DIR}"/nvim/lua/custom/ruby.lua ~/.config/nvim/lua/custom/ruby.lua
ln -fnsv "${DIR}"/nvim/lua/custom/go.lua ~/.config/nvim/lua/custom/go.lua
ln -fnsv "${DIR}"/nvim/lua/custom/custom.lua ~/.config/nvim/lua/custom/custom.lua

ln -fnsv "${DIR}"/.vimrc ~/.vimrc
ln -fnsv "${DIR}"/.bash_override ~/.bash_override
if [ "$(uname)" == "Darwin" ]; then
  grep -qxF 'source $HOME/.bash_override' $HOME/.bash_profile || echo 'source $HOME/.bash_override' >> $HOME/.bash_profile
elif [ "$(uname)" == "Linux" ]; then
  grep -qxF 'source $HOME/.bash_override' $HOME/.bashrc || echo 'source $HOME/.bash_override' >> $HOME/.bashrc
fi

mkdir -p ~/.config/tmux
ln -fnsv "${DIR}"/tmux/tmux.conf ~/.config/tmux/tmux.conf

CUSTOM_WEZTERM="${DIR}"/wezterm/custom.lua
if [ ! -e "${CUSTOM_WEZTERM}" ]; then
  cp "${CUSTOM_WEZTERM}".template "${CUSTOM_WEZTERM}"
fi

mkdir -p ~/.config/wezterm
ln -fnsv "${DIR}"/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
ln -fnsv "${CUSTOM_WEZTERM}" ~/.config/wezterm/custom.lua

mkdir -p ~/.config/zed
ln -fnsv "${DIR}"/zed/settings.json ~/.config/zed/settings.json
ln -fnsv "${DIR}"/zed/keymap.json ~/.config/zed/keymap.json
