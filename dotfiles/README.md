## Mac
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

## Ubuntu
```
sudo apt install curl gnome-tweaks gnome-shell-extensions ibus-mozc
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install bash coreutils direnv fd fzf kind lazydocker git neovim peco ripgrep tig tree z
sudo snap install vivaldi
sudo snap install intellij-idea-ultimate --classic
```

- https://qiita.com/Mike3906/items/3ed4137f915465f957b3
```
filename=JetBrainsMono.zip
extension="${filename##*.}"
filename="${filename%.*}"
mkdir ${filename} && pushd ${filename}
mv ../Downloads/JetBrainsMono.zip ../
unzip ../${filename}.${extension}
popd
mkdir -p ~/.fonts
mv ${filename} ~/.fonts/
fc-cache -fv
```
