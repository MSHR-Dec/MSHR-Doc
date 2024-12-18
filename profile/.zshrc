[[ -r ~/.znap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.znap/zsh-snap
source ~/.znap/zsh-snap/znap.zsh

zstyle ':znap:*' repos-dir ~/.znap/plugins

znap prompt sindresorhus/pure
zstyle :prompt:pure:path color magenta
zstyle :prompt:pure:git:branch color red
zstyle ':prompt:pure:prompt:*' color reset

znap source marlonrichert/zsh-autocomplete
znap source rupa/z

source <(fzf --zsh)

alias zfz='z | fzf'

[[ -f ~/.zsh_override ]] && source ~/.zsh_override
