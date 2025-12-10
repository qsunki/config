#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "$(fzf --bash)"

alias ls='/usr/bin/ls --color=auto'
alias la='/usr/bin/ls --color=auto -A'
alias l='/usr/bin/ls --color=auto -A'

alias grep='/usr/bin/grep --color=auto -I'

alias vi='nvim'
alias vir='nvim -R'
alias view='nvim -RM'

alias which='alias | which -i'

alias so='source'

alias j='jobs'

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

shopt -s autocd
shopt -s globstar
