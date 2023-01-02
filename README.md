```
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
```
brew install anyenv bash lazydocker git peco tig tree z
brew install --cask docker google-chrome intellij-idea slack visual-studio-code
anyenv init
anyenv install --init
anyenv install goenv
mkdir $HOME/go
```
