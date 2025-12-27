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
brew install --cask docker google-chrome hyper intellij-idea raycast slack vivaldi wezterm zed
anyenv init
anyenv install --init
```

## Manjaro
```
sudo pacman -Syyu
sudo pacman -S coreutils direnv fd fzf neovim peco ripgrep tig tree tree-sitter-cli ttf-firacode-nerd yay
git clone https://github.com/rupa/z ~/.config/z
mkdir -p ~/.config/git
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O .config/git/git-completion.bash
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O .config/git/git-prompt.sh
sudo usermod -a -G input $USER
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/99-input.rules
systemctl --user start xremap.service
systemctl --user enable xremap.service
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
