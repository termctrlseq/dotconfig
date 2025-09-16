#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# see bash(1)
HISTCONTROL=ignoredups:erasedups
HISTSIZE=999
shopt -s histappend globstar failglob

set -o vi # Bash vi mode
stty -ixon # Disable Ctrl-s/Ctrl-q start/stop flow control
export EDITOR='vim'
export PAGER='less'
export LESS='-R --mouse --wheel-lines=3' 

# add ~/.local/bin to PATH if not in it
[[ ":${PATH}:" != *:"$HOME/.local/bin":* ]] && \
  export PATH="$HOME/.local/bin:$PATH"

# Set LS_COLORS
# => dircolors --print-database > ~/.dir_colors
# Edit ~/.dir_colors as needed
[[ -f "$HOME/.dir_colors" ]] && eval "$(dircolors "$HOME/.dir_colors")"

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
  . /usr/share/bash-completion/bash_completion

[[ -x /usr/bin/xdg-open ]] && alias o='/usr/bin/xdg-open'
[[ -x /usr/bin/tgpt ]] && alias tgpt='/usr/bin/tgpt --log ~/tgpt_log.md'

# bat setup
if command -v bat >/dev/null 2>&1; then
  if command -v batman >/dev/null 2>&1; then
    alias man='batman'
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
if command -v mocword >/dev/null 2>&1; then
  export MOCWORD_DATA="$HOME/.local/share/mocword/mocword.sqlite"
fi

# Enable shell autocompletion for uv commands
if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion bash)"
fi

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
    exit_code="\[\e[1;38;5;1m\]$exit_code\[\e[0m\] "
  else
    exit_code=" "
  fi
  local jobs_count=$(jobs -p | wc -l)
  local jobs_str=
  (( jobs_count > 0 )) && jobs_str="\[\e[1;38;5;172m\]\j\[\e[0m\]"
  local venv=
  if [[ -v VIRTUAL_ENV_PROMPT ]]; then
    venv="\[\e[38;5;12m\]󰌠\[\e[4m\] ${VIRTUAL_ENV_PROMPT}\[\e[0m\] "
  fi
  local wdir="\w"
  [[ -v TMUX ]] && wdir="\W" # only show last part of cwd when in tmux
  if [[ -v SSH_CONNECTION ]]; then
    local is_ssh=
    is_ssh+="\[\e[38;5;8m\]"
    is_ssh+="\[\e[1;48;5;8;38;5;233m\]\u@\h\[\e[0m\]"
    is_ssh+="\[\e[2;38;5;235;48;5;8m\]\[\e[0m\]"
    # is_ssh+="\[\e[38;5;8m\]🭪\[\e[0m\]"
  fi
  # local git_branch="$(git branch --show-current 2>/dev/null)"
  # local git_str=
  # [[ -n git_branch ]] && git_str="\[\e[1;38;5;242m\][$git_branch]\[\e[0m\]"
  PS1=
  PS1+="$exit_code"
  PS1+="$venv"
  PS1+="\[\e[38;5;248m\]$wdir/"
  PS1+="$git_str"
  PS1+="$is_ssh"
  PS1+="$jobs_str"
  PS1+="\[\e[1;38;5;66m\]\$"
  PS1+="\[\e[0m\] "
}
# executed prior to issuing each primary prompt.
PROMPT_COMMAND=update_ps1
