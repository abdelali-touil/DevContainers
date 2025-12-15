#!/bin/bash
set -e

# Install Oh My Zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --unattended

# Set Zsh as default shell for devops user
chsh -s /bin/zsh devops || true

# Create .zshrc configuration
cat > /home/devops/.zshrc << 'ZSHEOF'
# Oh My Zsh configuration
export ZSH="/home/devops/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  git
  docker
  kubectl
  helm
  python
  node
  npm
  colored-man-pages
  colorize
  command-not-found
  extract
  history
  sudo
  web-search
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias ll='ls -lah'
alias la='ls -la'
alias l='ls -lF'
alias cd..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Docker aliases
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up'
alias dcd='docker compose down'

# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias kex='kubectl exec -it'

# Git aliases
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gst='git status'
alias gl='git log'

# Helm aliases
alias h='helm'
alias hls='helm list'
alias hch='helm chart'

# Neovim
alias nv='nvim'
alias vi='nvim'
alias vim='nvim'

# Utilities
alias grep='grep --color=auto'
alias cat='bat'
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias logs='journalctl -xe'

# Functions
mcd() {
  mkdir -p "$@" && cd "$_"
}

extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS

# Environment variables
export EDITOR=nvim
export VISUAL=nvim
export KUBECONFIG=${KUBECONFIG:-$HOME/.kube/config}
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Prompt customization (optional)
export PROMPT="%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$ "

# Load nvm if available
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Load rbenv if available
eval "$(rbenv init - zsh 2>/dev/null)" || true

# Load pyenv if available
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh 2>/dev/null)" || true
ZSHEOF

# Set ownership
chown -R 1000:1000 /home/devops/.oh-my-zsh /home/devops/.zshrc

echo "=== Zsh configuration completed ==="
