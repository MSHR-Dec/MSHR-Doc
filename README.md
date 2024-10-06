```
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
```
brew install anyenv bash direnv lazydocker git peco tig tree z
brew install --cask docker fig google-chrome intellij-idea raycast slack visual-studio-code
anyenv init
anyenv install --init
```
