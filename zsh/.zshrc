# homebrew
export PATH="/opt/homebrew/bin:$PATH"
typeset -U PATH

# zsh plugin manager
source /opt/homebrew/opt/zinit/zinit.zsh

# super smart autocompletions
zinit ice wait"0" lucid depth=1 pick"deja.plugin.zsh"
zinit light Giammarco-Ferranti/deja

# deja overrides
export DEJA_ACCEPT_KEY=^L
export DEJA_CYCLE_KEY=^N
export DEJA_CYCLE_FUZZY_KEY=
export DEJA_CYCLE_FUZZY_BACK_KEY=
export DEJA_TOGGLE_EMPTY_KEY=

# syntax highlighting
zinit light zsh-users/zsh-syntax-highlighting

# starship theme
eval "$(starship init zsh)"

# options
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt no_beep
setopt inc_append_history

# history
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# fzf
eval "$(fzf --zsh)"

# fzf overrides
export FZF_DEFAULT_OPTS='
  --layout=reverse
  --color=fg:#908caa,hl:#ebbcba
  --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
  --color=border:#403d52,header:#31748f,gutter:#191724
  --color=spinner:#f6c177,info:#9ccfd8
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
'

# alias

# eza
alias ls='eza --icons=always --group-directories-first'
alias la='eza --all --icons=always --group-directories-first'
alias la='eza --long --all --git --icons=always --group-directories-first'
alias tree='eza --tree --icons'

# bar
alias bat='bat'

# rg
alias grep='rg --color=auto'

# vim
alias vi='nvim'

# trash-cli
alias rm='trash'

# codium
alias codium='codium --new-window'

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

# llvm
export PATH=/opt/homebrew/opt/llvm/bin:$PATH

# java 21
# export PATH=/opt/homebrew/opt/openjdk@21/bin:$PATH

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
