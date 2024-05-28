# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

# List of plugins used
plugins=( git sudo zsh-256color zsh-autosuggestions zsh-syntax-highlighting asdf)
source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export EDITOR=/usr/bin/nvim

# Helpful aliases
alias  c='clear' # clear terminal
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias cll='clear && ll' # clear and long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias githist="git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --date=short --date-order"

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

#Display Pokemon
pokemon-colorscripts --no-title -r 1

# Path to cargo binaries
export PATH=$PATH:$HOME/.cargo/bin
# Path to go bin
export PATH=$PATH:$HOME/go/bin

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
