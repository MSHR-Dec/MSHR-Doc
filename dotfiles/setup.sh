#! /bin/bash

DIR=$(
  cd $(dirname $0)
  pwd
)

CUSTOM_REQUIREMENT="${DIR}"/nvim/lua/custom/requirements.lua
CUSTOM_LUA="${DIR}"/nvim/lua/custom/custom.lua
if [ ! -e "${CUSTOM_REQUIREMENT}" ]; then
  cp "${CUSTOM_REQUIREMENT}".template "${CUSTOM_REQUIREMENT}"
fi
if [ ! -e "${CUSTOM_LUA}" ]; then
  cp "${CUSTOM_LUA}".template "${CUSTOM_LUA}"
fi

mkdir -p ~/.config
# If ~/.config/nvim is a real directory, back it up before symlinking.
if [ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)
fi
ln -fnsv "${DIR}"/nvim ~/.config/nvim

PLUG_VIM="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim
if [ ! -e "${PLUG_VIM}" ]; then
  curl -fLo "${PLUG_VIM}" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
nvim --headless "+PlugInstall --sync" +qa

ln -fnsv "${DIR}"/.vimrc ~/.vimrc
ln -fnsv "${DIR}"/.bash_override ~/.bash_override
if [ "$(uname)" == "Darwin" ]; then
  grep -qxF 'source $HOME/.bash_override' $HOME/.bash_profile || echo 'source $HOME/.bash_override' >>$HOME/.bash_profile
elif [ "$(uname)" == "Linux" ]; then
  grep -qxF 'source $HOME/.bash_override' $HOME/.bashrc || echo 'source $HOME/.bash_override' >>$HOME/.bashrc
fi

mkdir -p ~/.config/tmux
ln -fnsv "${DIR}"/tmux/tmux.conf ~/.config/tmux/tmux.conf

CUSTOM_WEZTERM="${DIR}"/wezterm/custom.lua
if [ ! -e "${CUSTOM_WEZTERM}" ]; then
  cp "${CUSTOM_WEZTERM}".template "${CUSTOM_WEZTERM}"
fi

mkdir -p ~/.config/wezterm
ln -fnsv "${DIR}"/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
ln -fnsv "${DIR}"/wezterm/agent.lua ~/.config/wezterm/agent.lua
ln -fnsv "${CUSTOM_WEZTERM}" ~/.config/wezterm/custom.lua

mkdir -p ~/.config/zed
ln -fnsv "${DIR}"/zed/settings.json ~/.config/zed/settings.json
ln -fnsv "${DIR}"/zed/keymap.json ~/.config/zed/keymap.json

mkdir -p ~/.config/zed/themes
ln -fnsv "${DIR}"/zed/themes/new-darcula-jetbrains-syntax.json ~/.config/zed/themes/new-darcula-jetbrains-syntax.json

mkdir -p ~/.config/yazi
ln -fnsv "${DIR}"/yazi/yazi.toml ~/.config/yazi/yazi.toml
ln -fnsv "${DIR}"/yazi/theme.toml ~/.config/yazi/theme.toml

mkdir -p ~/.config/xremap
mkdir -p ~/.config/systemd/user
ln -fnsv "${DIR}"/xremap/config.yml ~/.config/xremap/config.yml
ln -fnsv "${DIR}"/xremap/xremap.service ~/.config/systemd/user/xremap.service

ln -fnsv "${DIR}"/.Brewfile ~/.Brewfile
CUSTOM_BREWFILE="${DIR}"/.Brewfile.local
if [ ! -e "${CUSTOM_BREWFILE}" ]; then
  cp "${CUSTOM_BREWFILE}".template "${CUSTOM_BREWFILE}"
fi
ln -fnsv "${CUSTOM_BREWFILE}" ~/.Brewfile.local
