function zfz() {
  local z=$(z | awk '{ print $2 }' | fzf --reverse)
  if [ -n "${z}" ]; then
    BUFFER="cd ${z}"
    zle accept-line
  fi
  zle clear-screen
}

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

zle -N zfz
bindkey '^z' zfz

[[ -f ~/.zsh_override ]] && source ~/.zsh_override
