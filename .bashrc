#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias    ls='ls --color=auto'
alias  grep='grep --color=auto'
alias pydoc='MANPAGER="vim +MANPAGER --not-a-term -" pydoc'
alias virsh='virsh -c qemu:///system'
alias virt-viewer='GDK_BACKEND=x11 virt-viewer -c qemu:///system --wait --hotkeys=release-cursor=alt+enter'

# see bash(1)
export       HISTSIZE=9999
export    HISTCONTROL='erasedups'
export HISTTIMEFORMAT="%F %T "

shopt -s histappend globstar

export EDITOR='vim'
export  PAGER='bat -p'
export   LESS='--RAW-CONTROL-CHARS --mouse'
export CDPATH="${HOME}:${HOME}/Code:${HOME}/.config"
export XDG_CONFIG_HOME="${HOME}/.config"

# Ignore ${HOME}/.git when in subdirectories
export GIT_CEILING_DIRECTORIES="${HOME}"

stty -ixon # Disable Ctrl-s/Ctrl-q start/stop flow control
set  -o vi # Bash vi mode

# Readline bindings
[[ -f "${HOME}/.bindrc" ]] && source "${HOME}/.bindrc"

# add ~/.local/bin to PATH if not in it
[[ ":${PATH}:" != *:"${HOME}/.local/bin":* ]] \
    && export PATH="${HOME}/.local/bin:${PATH}"

# Set LS_COLORS
if ! [[ -f "${HOME}/.dir_colors" ]]; then
    dircolors --print-database > "${HOME}/.dir_colors"
fi
eval "$(dircolors "${HOME}/.dir_colors")"

# bat setup
if command -v bat >/dev/null 2>&1; then
    export BAT_STYLE='changes,header'
    if command -v batman >/dev/null 2>&1; then
        export BATPIPE=color
        eval   "$(batpipe)"
        eval   "$(batman --export-env)"
        alias  man='BAT_STYLE=plain batman'
    fi
    if  [[  -f "${HOME}/.config/bat/themes/Spx.tmTheme" ]]; then
        export BAT_THEME='Spx'
    else
        export BAT_THEME='base16'
    fi
fi

if pgrep -xu "${USER}" qtile >/dev/null 2>&1; then
    alias reboot='qtile cmd-obj -o root -f shutdown; sleep 1; reboot'
fi

# rustup shell setup
[[ -x /usr/bin/cargo && ":${PATH}:" != *:"${HOME}/.cargo/bin":* ]] \
    && export PATH="${HOME}/.cargo/bin:${PATH}"
# Mocword - Predict next words
command -v mocword >/dev/null 2>&1 \
    && export MOCWORD_DATA="${HOME}/.local/share/mocword/mocword.sqlite"

# Enable shell autocompletion for uv commands
command -v uv >/dev/null 2>&1 \
    && eval "$(uv generate-shell-completion bash)"

# Prompt setup
# Displayed after reading a command and before the command is executed.
PS0="\e[2 q\e]112\a" # block cursor, reset color
# Primary prompt is set with prompt_command
PS1="\W \$ "
# Continuation prompt
PS2=" \[\e[1;38;5;8m\]...\[\e[0m\] "
prompt_command() {
    local exit_code="$?"
    if (( exit_code != 0 )); then
        if (( exit_code > 128 )); then
            local sig
            sig="$(kill -l ${exit_code} 2>/dev/null)"
            [[ -n "${sig}" ]] && exit_code="SIG${sig}"
        fi
        exit_code="\[\e[1;31m\]${exit_code}\[\e[0m\] "
    else
        exit_code=" "
    fi
    local jobs_count
    jobs_count="$(jobs -p | wc -l)"
    local jobs_str=
    (( jobs_count > 0 )) && jobs_str="\[\e[1;38;5;172m\]\j\[\e[0m\]"
    local venv=
    if [[ -v VIRTUAL_ENV_PROMPT ]]; then
        venv="\[\e[38;5;12m\]󰌠\[\e[4m\] ${VIRTUAL_ENV_PROMPT}\[\e[0m\] "
    fi
    local cwd="\W"
    cwd="\[\e[38;5;248m\]${cwd}\[\e[1;38;5;66m\]/"
    local is_ssh=
    if [[ -v SSH_CONNECTION ]]; then
        is_ssh+="\[\e[38;5;8m\]"
        is_ssh+="\[\e[1;48;5;8;38;5;233m\]\u@\h\[\e[0m\]"
        is_ssh+="\[\e[2;38;5;235;48;5;8m\]\[\e[0m\]"
    fi
    PS1=
    PS1+="\[\e[0m\]"
    PS1+="${exit_code}"
    PS1+="${venv}"
    PS1+="${cwd}"
    PS1+="${is_ssh}"
    PS1+="${jobs_str}"
    PS1+="\[\e[1;38;5;66m\]\$"
    PS1+="\[\e[0m\] "
}
# executed prior to issuing each primary prompt.
PROMPT_COMMAND=prompt_command
