```
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
```
brew install anyenv bash coreutils direnv fd font-jetbrains-mono-nerd-font fzf kind lazydocker git neovim peco ripgrep tig tree z
brew install --cask docker google-chrome hyper intellij-idea raycast slack vivaldi
anyenv init
anyenv install --init
```
