# peco
# see: https://qiita.com/yungsang/items/09890a06d204bf398eea
export HISTCONTROL="ignoredups"
peco-history() {
  local NUM=$(history | wc -l)
  local FIRST=$(-1*(NUM-1))

  if [ $FIRST -eq 0 ] ; then
    history -d $((HISTCMD-1))
    echo "No history" >&2
    return
  fi

  local CMD=$(fc -l $FIRST | sort -k 2 -k 1nr | uniq -f 1 | sort -nr | sed -E 's/^[0-9]+[[:blank:]]+//' | peco | head -n 1)

  if [ -n "$CMD" ] ; then
    history -s $CMD

    if type osascript > /dev/null 2>&1 ; then
      (osascript -e 'tell application "System Events" to keystroke (ASCII character 30)' &)
    fi
  else
    history -d $((HISTCMD-1))
  fi
}

source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/profile.d/z.sh
GIT_PS1_SHOWDIRTYSTATE=true
PS1='\[\033[0m\]:\[\033[35m\]\w \[\033[31m\]$(__git_ps1)\n\[\033[0m\]$ '

alias ls='ls -G'
alias glog='git log --oneline'
alias rand='cat /dev/urandom | base64 | fold -w 10 | head -n 1'
alias reload='exec $SHELL -l'
alias his='peco-history'
alias lzd='lazydocker'

PATH="/usr/local/bin:$PATH"
PATH="$GOPATH/bin:$PATH"

eval "$(anyenv init -)"
