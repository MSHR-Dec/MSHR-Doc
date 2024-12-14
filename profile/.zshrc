source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
source /opt/homebrew/etc/profile.d/z.sh

zstyle ':completion:*:*:git:*' script /opt/homebrew/etc/bash_completion.d/git-completion.bash
autoload -Uz compinit && compinit
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true

setopt PROMPT_SUBST ; PS1='%F{reset}:%F{magenta}%~ %F{red}$(__git_ps1)
%F{reset}$ '

eval "$(/opt/homebrew/bin/brew shellenv)"

export GOPATH="$HOME/go"
export PATH="/usr/local/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

alias ls='gls --color'
alias reload='exec $SHELL -l'
alias lzd='lazydocker'
alias v='nvim'
