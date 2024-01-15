#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Aliases

# Long Format List
alias ll="ls -AFhosv $*"
alias cll="clear && ll"

# Git
alias githist="git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --date=short --date-order"

# Code Insiders
alias code="code-insiders $*"
