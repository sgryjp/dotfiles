# shellcheck shell=bash
# Bash-specific interactive setup. This should be sourced from ~/.bashrc.

# Prompt
rst='\[\e[0m\]'
ul='\[\e[4m\]'
red='\[\e[0;31m\]'
PS1="\$("
PS1+='status=$?; '
# shellcheck disable=SC2154
PS1+="if [ \$status -ne 0 ]; then echo \"${red}[\$status] ${rst}\"; fi"
PS1+=")"
PS1+="\u@"
PS1+="\h:${ul}\w${rst}\$ "
unset rst ul red
export PS1

# Key bindings
set -o emacs

# fzf
if command -v fzf >/dev/null; then
  # https://junegunn.github.io/fzf/shell-integration/
  eval "$(fzf --bash)"
fi
