# .bash_aliases

shopt -s globstar

HISTSIZE=20000
HISTFILESIZE=20000
HISTIGNORE='[bf]g:history:ls:pushd:popd:pwd:Ej:ea:ev:startmux'

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

export PIP_REQUIRE_VIRTUALENV=true

unalias ls
alias ls='ls -F'

alias cp='cp -i'
alias mv='mv -i'

alias ...='cd ../../'
alias ..='cd ..'
alias cdc='cd ~/code'
alias cdd='cd ~/code/dotfiles'
alias cdn='cd ~/notes'
alias cdt='cd ~/tmp'
alias cdw='cd ~/work'
alias cdv='cd ~/code/vimconfig'

alias info='info --vi-keys'

alias l1='ls -1'
alias ls.='ls -ld .?*'
alias lss='find . -maxdepth 1 -type l -ls'

alias Ej='vim -c Ej'
alias ea='vim ~/.bash_aliases && . ~/.bash_aliases'
alias ev='vim ~/.vim/vimrc'
alias path='env | grep PATH | tr ":" "\n"'
alias ptpython='ptpython --dark-bg'
alias pv='which python; python --version'

fixssh() { eval "$(tmux show-env -s | grep '^SSH_')" ; }

_mkvirtualenv(){
    python3 -m venv .venv
cat << EOF > .envrc
source .venv/bin/activate
unset PS1
echo "using $(python --version) ($(which python))"
EOF
}

mkvirtualenv() {
    if [[ -d .venv ]]; then
        read -p "Replace existing virtual environment? " -n 1 -r; echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf .venv .envrc
            _mkvirtualenv
        fi
    else
        _mkvirtualenv
    fi
}

if command -v batcat &> /dev/null; then
    alias cat='batcat'
fi

if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

if command -v fdfind &> /dev/null; then
    alias fd='fdfind'
fi

startmux() {
    session_name=$(hostname -s)
    bgcolor="green"
    if [[ -n "$SSH_CONNECTION" ]]; then
        bgcolor="cyan"
    fi
    tmux -2 att -t "$session_name" ||
        tmux -2 \
            new -s "$session_name" -n notes \; \
            set -g status-style "bg=$bgcolor" \; \
            set -ag status-style "fg=black" \; \
            send-keys "cd ~/notes" C-m \; \
            neww -n code \; \
            send-keys "cd ~/code" C-m \; \
            neww \; \
            select-window -t notes
}
alias sm='startmux'
