_zfz() {
  cd $(z | awk '{ print $2 }' | fzf --reverse)
}

_zhz() {
  ssh $(grep -E "^Host " ~/.ssh/config | grep -v "*" | sed -e 's/Host[ ]*//g' | fzf)
}

source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
source /opt/homebrew/etc/bash_completion.d/git-completion.bash
source /opt/homebrew/etc/profile.d/z.sh

GIT_PS1_SHOWDIRTYSTATE=true
PS1='\[\033[0m\]:\[\033[35m\]\w \[\033[31m\]$(__git_ps1)\n\[\033[0m\]$ '

alias ls='gls --color'
alias reload='exec $SHELL -l'
alias lzd='lazydocker'
alias k='kubectl'
alias v='nvim'
alias zz='_zfz'
alias zh='_zhz'

export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(anyenv init -)"
eval "$(direnv hook bash)"
eval "$(fzf --bash)"

if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

source $HOME/.bash_override

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
