#!/usr/bin/env bash

SUDO=""
if [ "$EUID" -ne 0 ]; then
  SUDO="sudo"
fi

if [[ "$(uname)" == "Darwin" ]]; then
  ./install_deps.mac.sh
else
  ./install_deps.ubuntu.sh
fi

# Function to log warnings
function warn {
  echo "Warning: $1"
}

if [[ "$(uname)" == "Linux" ]]; then
  # Backup current /etc/pam.d/chsh
  PAM_CHSH_FILE="/etc/pam.d/chsh"
  PAM_CHSH_BACKUP="/etc/pam.d/chsh.bak"
  if [ ! -f "$PAM_CHSH_BACKUP" ]; then
    echo "Backing up $PAM_CHSH_FILE..."
    if ! $SUDO cp "$PAM_CHSH_FILE" "$PAM_CHSH_BACKUP"; then
      warn "Failed to back up $PAM_CHSH_FILE. This step will be skipped."
    fi
  else
    echo "$PAM_CHSH_BACKUP already exists. Skipping backup."
  fi

  # Temporarily modify /etc/pam.d/chsh
  echo "Temporarily modifying $PAM_CHSH_FILE to allow shell change without password..."
  if ! $SUDO sed -i '/auth/s/^/#/' "$PAM_CHSH_FILE"; then
    warn "Failed to comment out 'auth' lines in $PAM_CHSH_FILE."
  fi
  if ! echo "auth       sufficient   pam_shells.so" | $SUDO tee -a "$PAM_CHSH_FILE" >/dev/null; then
    warn "Failed to append 'auth sufficient pam_shells.so' to $PAM_CHSH_FILE."
  fi

  # Update package list and install Zsh
  echo "Installing Zsh..."
  if ! ($SUDO apt update && $SUDO apt install -y zsh); then
    warn "Failed to install Zsh. Make sure you have $SUDO privileges and are connected to the internet."
  fi

  # Verify Zsh installation
  if ! command -v zsh >/dev/null; then
    warn "Zsh installation check failed. Zsh may not be installed or accessible."
  else
    echo "Zsh is installed."
  fi

  # Change the default shell to Zsh
  echo "Changing the default shell to Zsh..."
  if ! chsh -s "$(which zsh)"; then
    warn "Failed to change the default shell to Zsh. You may need to do it manually."
  else
    echo "Successfully changed the default shell to Zsh."
  fi

  # Restore original /etc/pam.d/chsh
  echo "Restoring original $PAM_CHSH_FILE..."
  if [ -f "$PAM_CHSH_BACKUP" ]; then
    if ! $SUDO mv "$PAM_CHSH_BACKUP" "$PAM_CHSH_FILE"; then
      warn "Failed to restore original $PAM_CHSH_FILE. Ensure that it is secured manually."
    else
      echo "Successfully restored $PAM_CHSH_FILE."
    fi
  else
    warn "$PAM_CHSH_BACKUP not found. Skipping restoration of $PAM_CHSH_FILE."
  fi
fi

# Download and install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is already installed. Skipping this step."
else
  if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
    warn "Failed to install Oh My Zsh."
  else
    echo "Successfully installed Oh My Zsh."
  fi
fi
git clone https://github.com/jeffreytse/zsh-vi-mode $HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode || true

# Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh" # in lieu of restarting the shell
nvm install 22

# Devcontainer CLI
npm i --global @devcontainers/cli

mv .zshrc $HOME/.zshrc

mkdir -p ~/.config

# Install formatters for nvim
pipx install isort
pipx install black

# Setup up neovim
rm -rf ~/.config/nvim || true
mv nvim ~/.config/nvim

# Setup tmux
rm -rf ~/.config/tmux || true
mv tmux ~/.config/tmux

# Setup kitty
rm -rf ~/.config/kitty || true
mv kitty ~/.config/kitty

echo -e "\nSetup is complete! Please restart your terminal or run 'exec zsh' to start using Zsh with Powerlevel10k and Oh My Zsh."
