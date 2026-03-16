export PATH="$HOME/.asdf/shims:$PATH"
export PATH="$HOME/.asdf/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.fzf/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export EDITOR=nvim

# export LIBGL_ALWAYS_SOFTWARE=1 # Force software rendering for OpenGL (instead of GPU)

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

# hyde_plugins=(sudo git zsh-256color zsh-autosuggestions zsh-syntax-highlighting)

# zinit plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting

# TODO: Look into moving starship to zinit?
# https://github.com/zdharma-continuum/zinit?tab=readme-ov-file#plugins-and-snippets


# Added by initial installer
# ==========================
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -v
# Fix special keys in vi mode
bindkey '^[[3~' delete-char           # Delete key
bindkey '^[[1;5D' backward-word       # Ctrl+Left
bindkey '^[[1;5C' forward-word        # Ctrl+Right
bindkey '^[[H' beginning-of-line      # Home
bindkey '^[[F' end-of-line            # End
bindkey '^[[1~' beginning-of-line     # Home (alternate)
bindkey '^[[4~' end-of-line           # End (alternate)
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/dalton/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

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
alias lg='lazygit'
alias bat='batcat'

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'


# Shell integrations
# ==================
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init --cmd cd zsh)"


# asdf completion (if asdf is available)
if command -v asdf >/dev/null 2>&1; then
  source <(asdf completion zsh)
fi

# opencode
export PATH=/home/dalton/.opencode/bin:$PATH
eval "$(uv generate-shell-completion zsh)"
