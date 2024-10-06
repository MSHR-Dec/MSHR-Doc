```
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
```
brew install anyenv bash direnv fzf kind lazydocker git peco tig tree z
brew install --cask docker fig google-chrome hyper intellij-idea raycast slack vivaldi
anyenv init
anyenv install --init
```
