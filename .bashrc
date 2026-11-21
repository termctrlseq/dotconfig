#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -r "${HOME}/.secrets" ]] && source "${HOME}/.secrets"

alias    ls='ls --color=auto'
alias  grep='grep --color=auto'
alias  clip='xclip -in -selection clipboard -rmlastnl'
alias virsh='virsh -c qemu:///system'
alias virt-viewer='GDK_BACKEND=x11 virt-viewer -c qemu:///system --wait --hotkeys=release-cursor=alt+enter'

# see bash(1)
export       HISTSIZE=9999
export     HISTIGNORE='&:[ ]*'
export    HISTCONTROL='erasedups'
export HISTTIMEFORMAT='%F %T '

shopt -s histappend globstar

# shellcheck disable=SC2016
export     LESS='--use-color --mouse FRDP232.242$'
export   EDITOR='vim'
export MANPAGER='less'
export XDG_CONFIG_HOME="${HOME}/.config"

# Colorize Man Pages: https://www.youtube.com/watch?v=D0sG2fj0G4Y
# see less(1) § ENVIRONMENT: LESS_TERMCAP_xx
# and terminfo(5) § Standard Capabilities (3rd column 'TC' should match xx)
export MANROFFOPT="-c"
export LESS_TERMCAP_so=$'\e[7m' # standout start
export LESS_TERMCAP_se=$'\e[0m' # standout end
export LESS_TERMCAP_us=$'\e[1;4;38;5;104m' # underscore start
export LESS_TERMCAP_ue=$'\e[0m' # underscore end
export LESS_TERMCAP_md=$'\e[1;38;5;103m' # bold mode
export LESS_TERMCAP_me=$'\e[0m' # turn off all attributes


# Ignore ${HOME}/.git when in subdirectories
export GIT_CEILING_DIRECTORIES="${HOME}"

stty -ixon # Disable Ctrl-s/Ctrl-q start/stop flow control
set  -o vi # Bash vi mode

# add ~/.local/bin to PATH if not in it
[[ ":${PATH}:" != *:"${HOME}/.local/bin":* ]] \
    && export PATH="${HOME}/.local/bin:${PATH}"

# Set LS_COLORS
dir_colors="${HOME}/.dir_colors"
if [[ ! -e "$dir_colors" ]]; then
    dircolors --print-database > "$dir_colors"
fi
[[ -r "$dir_colors" ]] && eval "$(dircolors "$dir_colors")"

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

# Set up fzf key bindings and fuzzy completion
command -v fzf >/dev/null 2>&1 \
    && eval "$(fzf --bash)"

# Readline bindings
[[ -r "${HOME}/.bindrc" ]] && source "${HOME}/.bindrc"
[[ -r "${HOME}/.cd_histrc" ]] && source "${HOME}/.cd_histrc"

# Prompt setup
# Displayed after reading a command and before the command is executed.
# block cursor, reset cursor color, erase from cursor to end of display
PS0="\[\e[2 q\e]112\a\e[J\]"
# Primary prompt is set with prompt_command
PS1="\W \$ "
PS1_LEN=
# Continuation prompt
PS2=" \[\e[1;38;5;8m\]...\[\e[0m\] "

prompt_command() {
    local exit_code="$?" ps_one=""
    if (( exit_code != 0 )); then
        if (( exit_code > 128 )); then
            local sig
            sig="$(kill -l "$((exit_code - 128))" 2>/dev/null)"
            [[ -n "${sig}" ]] && exit_code="SIG${sig}"
        fi
        ps_one+="${exit_code} "
        exit_code="\[\e[1;31m\]${exit_code}\[\e[0m\] "
    else
        exit_code=" "
        ps_one+=" "
    fi

    local jobs_count
    jobs_count="$(jobs -p | wc -l)"
    local jobs_str=
    (( jobs_count > 0 )) && jobs_str="\[\e[1;38;5;172m\]\j\[\e[0m\]" && ps_one+="\j"

    local venv
    if [[ -v VIRTUAL_ENV_PROMPT ]]; then
        venv="\[\e[38;5;12m\]󰌠\[\e[4m\] ${VIRTUAL_ENV_PROMPT}\[\e[0m\] "
        ps_one+="󰌠 ${VIRTUAL_ENV_PROMPT} "
    fi

    local cwd="\[\e[38;5;248m\]\W\[\e[1;38;5;66m\]/"
    ps_one+="\W"

    local is_ssh
    if [[ -v SSH_CONNECTION ]]; then
        is_ssh+="\[\e[38;5;8m\]"
        is_ssh+="\[\e[1;48;5;8;38;5;233m\]\u@\h\[\e[0m\]"
        is_ssh+="\[\e[2;38;5;235;48;5;8m\]\[\e[0m\] "
        ps_one+="\u@\h "
    fi

    PS1="\[\e[0m\]"
    PS1+="${exit_code}"
    PS1+="${is_ssh}"
    PS1+="${venv}"
    PS1+="${cwd}"
    PS1+="${jobs_str}"

    # start new line when prompt is longer than a third of the terminal width
    local ps_one_exp="${ps_one@P}" tw
    PS1_LEN=${#ps_one_exp}
    tw="$COLUMNS"
    if (( PS1_LEN > tw / 3 )); then
        PS1+="\n\[\e[1;38;5;66m\]_"
        PS1_LEN=0
    fi

    PS1+="\[\e[1;38;5;66m\]\$"
    PS1+="\[\e[0m\] "

    update-cd-hist
}
# executed prior to issuing each primary prompt.
PROMPT_COMMAND=prompt_command

# vim: ft=sh sw=4 ts=4 sts=4
