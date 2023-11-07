# .bash_aliases

shopt -s globstar

HISTSIZE=20000
HISTFILESIZE=20000
HISTIGNORE='[bf]g:history:ls:pushd:popd:pwd'

export EDITOR=vim
export LESS=-FRXM
export MANPAGER=less
export PAGER=less
export MINIKUBE_IN_STYLE=false

if type __git_ps1 &>/dev/null; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    PS1='\u@\h:\w(\j)$(__git_ps1 " (%s)")$ '
else
    PS1='\u@\h:\w(\j)$ '
fi

if [[ -f /usr/local/bin/aws_completer ]]; then
    complete -C '/usr/local/bin/aws_completer' aws
fi

if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    . /usr/share/doc/fzf/examples/key-bindings.bash
fi

if command -v minikube &>/dev/null; then
    source <(minikube completion bash)
fi

if command -v kubectl &>/dev/null; then
    source <(kubectl completion bash)
fi

export PYTHONSTARTUP=~/.pythonstartup
alias python3='/usr/bin/python3.11'
alias ptpython='ptpython --dark-bg'

unalias ls
alias ls='ls -F'

alias cp='cp -i'
alias mv='mv -i'

alias ...='cd ../../'
alias ..='cd ..'
alias cda='cd ~/archive'
alias cdd='cd ~/Downloads'
alias cdn='cd ~/notes'
alias cdp='cd ~/proj'
alias cds='cd ~/src'
alias cdt='cd ~/tmp'
alias cdv='cd ~/Videos'

alias info='info --vi-keys'

alias l1='ls -1'
alias ls.='ls -ld .?*'
alias lss='find . -maxdepth 1 -type l -ls'

alias Ej='vim -c Ej'
alias ea='vim ~/.bash_aliases && . ~/.bash_aliases'
alias path='env | grep PATH | tr ":" "\n"'

fixssh() { eval "$(tmux show-env -s | grep '^SSH_')" ; }

_mkvirtualenv() {
    python3 -m venv .venv
}

_mkenvrc() {
cat << EOF > .envrc
source .venv/bin/activate
unset PS1
EOF
}

mkvirtualenv() {
    if [[ -d .venv ]]; then
        read -p "Replace existing virtual environment? " -n 1 -r; echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf .venv
            _mkvirtualenv
        fi
    else
        _mkvirtualenv
    fi
    if [[ -f .envrc ]]; then
        read -p "Replace existing .envrc file? " -n 1 -r; echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf .envrc
            _mkenvrc
        fi
    else
        _mkenvrc
    fi
}

if command -v batcat &> /dev/null; then
    alias cat='batcat'
fi

if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

startmux() {
    session_name=$(hostname -s)
    bgcolor="green"
    fgcolor="black"
    if [[ -n "$SSH_CONNECTION" ]]; then
        bgcolor="cyan"
    fi
    tmux -2 att -t "$session_name" ||
        tmux -2 \
            new -s "$session_name" -n notes \; \
            set -g status-style "bg=$bgcolor" \; \
            set -ag status-style "fg=$fgcolor" \; \
            send-keys "cd ~/notes; vim -c Ej" C-m \; \
            neww -n proj \; \
            send-keys "cd ~/proj; ls -1" C-m \; \
            neww -n repl \; \
            send-keys "cd ~/proj/python/repl; source .venv/bin/activate; ptpython" C-m \; \
            neww -n pydocs \; \
            send-keys "cd ~/python-3.12.0-docs-html; python3 -m http.server" C-m \; \
            neww -n youtube-dl \; \
            send-keys "cd ~/youtube-dl; source .venv/bin/activate" C-m \; \
            neww \; \
            select-window -t proj
}
alias sm=startmux
