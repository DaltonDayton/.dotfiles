export PATH="$HOME/.asdf/shims:$PATH"
export PATH="$HOME/.asdf/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/fzf/bin:$PATH"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Zinit Update Commands
# zinit self-update
# zinit update

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Add in snippets
# zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
# Home key
bindkey '\e[1~' beginning-of-line
bindkey '\e[H' beginning-of-line
# End key
bindkey '\e[4~' end-of-line
bindkey '\e[F' end-of-line
# Ctrl+Left Arrow key
bindkey '^[[1;5D' backward-word
# Ctrl+Right Arrow key
bindkey '^[[1;5C' forward-word

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'bat.exe {-l} --color=always'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'bat.exe {-l} --color=always'

# Aliases
alias  c='clear' # clear terminal
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias cll='clear && ll' # clear and long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias githist="git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --date=short --date-order"
alias githistall="git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --all --date=short --date-order"
alias ff="fzf --preview 'batcat {-1} --color=always'"
alias sz="source ~/.zshrc"
alias poetryactivate='source $(poetry env info --path)/bin/activate'
alias pa='poetryactivate'
alias pd='deactivate'

alias gittag="git log --no-walk --tags --pretty='%h %d %s' --decorate=full"
function gitlogpr() {
  git log $1..HEAD --oneline | grep "Merged PR"
}

alias gbr="git checkout azure && git pull"
# Docker
alias dcb="docker compose build"
alias dcu="docker compose up"
alias dcbu="dcb && dcu"
alias dabw="docker attach builder-web-1"
alias dabs="docker attach builder-sidekiq-1"
alias dasw="docker attach systemd-web-1"
alias dass="docker attach systemd-sidekiq-1"

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# fd() {
#   preview="git diff $@ --color=always -- {-1}"
#   git diff $@ --name-only | fzf -m --ansi --preview $preview
# }

showPreview()
{
  gitFilePreview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview "$gitFilePreview"
}
fd()
{
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if [ -d .git ]; then
      showPreview > /dev/null
    else
      gitRepoDir=$(git rev-parse --git-dir | sed 's/.git//')
      pushd $gitRepoDir > /dev/null
      showPreview > /dev/null
      popd > /dev/null
    fi
  else
    echo "Error: Not inside a git repository."
  fi
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
