#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# see bash(1)
export HISTCONTROL='erasedups:ignorespace'
export HISTSIZE=9999
export HISTFILE=~/.bash_history
export HISTTIMEFORMAT="%F %T "
shopt -s histappend globstar failglob

export EDITOR='vim'
export PAGER='bat -p'
export LESS='-R --mouse --wheel-lines=3' 
m() { man "$@" | vim +MANPAGER --not-a-term -; }

stty -ixon # Disable Ctrl-s/Ctrl-q start/stop flow control
set -o vi # Bash vi mode
# Ctrl-o to quickly switch emacs/vi modes
bind -m vi-command '"\C-o": emacs-editing-mode'
bind -m vi-insert  '"\C-o": emacs-editing-mode'
bind -m emacs      '"\C-o": vi-editing-mode'
# invoke the manual for the command preceding the cursor by pressing Alt+h.
run-help() { h $READLINE_LINE; }
bind -m vi-command -x '"\eh": run-help'
bind -m vi-insert  -x '"\eh": run-help'
bind -m emacs      -x '"\eh": run-help'

# add ~/.local/bin to PATH if not in it
[[ ":${PATH}:" != *:"$HOME/.local/bin":* ]] && \
    export PATH="$HOME/.local/bin:$PATH"

# Set LS_COLORS
# => dircolors --print-database > ~/.dir_colors
# Edit ~/.dir_colors as needed
[[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors "$HOME/.dir_colors")"

command -v xdg-open >/dev/null 2>&1 && alias o='xdg-open'
command -v tgpt >/dev/null 2>&1 && alias tgpt='tgpt --log ~/tgpt_log.md'

# bat setup
if command -v bat >/dev/null 2>&1; then
    export BAT_STYLE="changes,header,numbers"
    if command -v batman >/dev/null 2>&1; then
        alias man='BAT_STYLE=plain batman'
        export BATPIPE=color
        eval "$(batpipe)"
        eval "$(batman --export-env)"
    fi
    if [[ -f ~/.config/bat/themes/My-Theme.tmTheme ]]; then
        export BAT_THEME="My-Theme"
    else
        export BAT_THEME="base16"
    fi
fi

# X11 cursor theme
[[ -v WAYLAND_DISPLAY ]] || export XCURSOR_THEME=Adwaita

# rustup shell setup
[[ -x /usr/bin/cargo && ":${PATH}:" != *:"$HOME/.cargo/bin":* ]] && \
    export PATH="$HOME/.cargo/bin:$PATH"
# Mocword - Predict next words
command -v mocword >/dev/null 2>&1 &&\
    export MOCWORD_DATA="$HOME/.local/share/mocword/mocword.sqlite"

# Enable shell autocompletion for uv commands
command -v uv >/dev/null 2>&1 &&\
    eval "$(uv generate-shell-completion bash)"

# Prompt setup
# Displayed after reading a command and before the command is executed.
PS0="\e[2 q" # block cursor
# Primary prompt
PS1="\W \$ "
# Continuation prompt
PS2=" \[\e[1;38;5;8m\]...\[\e[0m\] "
update_ps1() {
    local exit_code="$?"
    if (( $exit_code != 0 )); then
        if (( $exit_code > 128 )); then
            local sig="$(kill -l $exit_code 2>/dev/null)"
            [[ -n "$sig" ]] && exit_code="SIG$sig"
        fi
        exit_code="\[\e[1;31m\]$exit_code\[\e[0m\] "
    else
        exit_code=" "
    fi
    local jobs_count="$(jobs -p | wc -l)"
    local jobs_str=
    (( jobs_count > 0 )) && jobs_str="\[\e[1;38;5;172m\]\j\[\e[0m\]"
    local venv=
    if [[ -v VIRTUAL_ENV_PROMPT ]]; then
        venv="\[\e[38;5;12m\]󰌠\[\e[4m\] ${VIRTUAL_ENV_PROMPT}\[\e[0m\] "
    fi
    local cwd="\W"
    cwd="\[\e[38;5;248m\]$cwd\[\e[1;38;5;66m\]/"
    if [[ -v SSH_CONNECTION ]]; then
        local is_ssh=
        is_ssh+="\[\e[38;5;8m\]"
        is_ssh+="\[\e[1;48;5;8;38;5;233m\]\u@\h\[\e[0m\]"
        is_ssh+="\[\e[2;38;5;235;48;5;8m\]\[\e[0m\]"
    fi
    PS1=
    PS1+="$exit_code"
    PS1+="$venv"
    PS1+="$cwd"
    PS1+="$git_str"
    PS1+="$is_ssh"
    PS1+="$jobs_str"
    PS1+="\[\e[1;38;5;66m\]\$"
    PS1+="\[\e[0m\] "
}
# executed prior to issuing each primary prompt.
PROMPT_COMMAND=update_ps1
