source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
PS1='\[\033[0m\]:\[\033[35m\]\w \[\033[31m\]$(__git_ps1)\n\[\033[0m\]$ '

alias ls='ls -G'
alias glog='git log --oneline'

PATH="/usr/local/bin:$PATH"
PATH="$GOPATH/bin:$PATH"

eval "$(anyenv init -)"
