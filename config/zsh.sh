#!/bin/bash
set -e

USER_NAME=${USER_NAME:-devops}
USER_HOME=${USER_HOME:-/home/$USER_NAME}

# Create user if it doesn't exist
if ! id -u "$USER_NAME" >/dev/null 2>&1; then
    echo "Creating user $USER_NAME..."
    useradd -m -s /bin/bash "$USER_NAME"
fi

# Install prerequisites for Oh My Zsh (if missing)
if ! command -v zsh >/dev/null 2>&1; then
    echo "Installing zsh..."
    apt-get update && apt-get install -y zsh wget git
fi

# Install Oh My Zsh unattended
sudo -u "$USER_NAME" sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -- --unattended

# Set Zsh as default shell (ignore errors if chsh unavailable)
if command -v chsh >/dev/null 2>&1; then
    chsh -s "$(which zsh)" "$USER_NAME" || true
fi

# Ensure Oh My Zsh folder exists
OH_MY_ZSH="$USER_HOME/.oh-my-zsh"
mkdir -p "$OH_MY_ZSH"

# Write .zshrc as the user
sudo -u "$USER_NAME" tee "$USER_HOME/.zshrc" >/dev/null << 'ZSHEOF'
# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git docker kubectl helm python node npm colored-man-pages colorize command-not-found extract history sudo web-search)
source $ZSH/oh-my-zsh.sh

# Aliases (simplified for brevity)
alias ll='ls -lah'
alias d='docker'
alias k='kubectl'
alias g='git'
alias nv='nvim'

# Replace vi and vim with nvim
alias vi='nvim'
alias vim='nvim'

# Functions
mcd() { mkdir -p "$@" && cd "$_"; }
extract() { 
  if [ -f "$1" ]; then 
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# History & environment
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
export EDITOR=nvim
export VISUAL=nvim
ZSHEOF

# Set ownership correctly
chown -R "$USER_NAME:$USER_NAME" "$OH_MY_ZSH" "$USER_HOME/.zshrc"

echo "=== Zsh configuration completed for $USER_NAME ==="
