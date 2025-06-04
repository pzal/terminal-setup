#!/usr/bin/env bash

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
    if ! sudo cp "$PAM_CHSH_FILE" "$PAM_CHSH_BACKUP"; then
      warn "Failed to back up $PAM_CHSH_FILE. This step will be skipped."
    fi
  else
    echo "$PAM_CHSH_BACKUP already exists. Skipping backup."
  fi

  # Temporarily modify /etc/pam.d/chsh
  echo "Temporarily modifying $PAM_CHSH_FILE to allow shell change without password..."
  if ! sudo sed -i '/auth/s/^/#/' "$PAM_CHSH_FILE"; then
    warn "Failed to comment out 'auth' lines in $PAM_CHSH_FILE."
  fi
  if ! echo "auth       sufficient   pam_shells.so" | sudo tee -a "$PAM_CHSH_FILE" >/dev/null; then
    warn "Failed to append 'auth sufficient pam_shells.so' to $PAM_CHSH_FILE."
  fi

  # Update package list and install Zsh
  echo "Installing Zsh..."
  if ! (sudo apt update && sudo apt install -y zsh); then
    warn "Failed to install Zsh. Make sure you have sudo privileges and are connected to the internet."
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
    if ! sudo mv "$PAM_CHSH_BACKUP" "$PAM_CHSH_FILE"; then
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

# Clone Powerlevel10k theme into Oh My Zsh custom themes directory
echo "Installing Powerlevel10k..."
THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$THEME_DIR" ]; then
  echo "Powerlevel10k is already installed. Skipping this step."
else
  if ! git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"; then
    warn "Failed to install Powerlevel10k."
  else
    echo "Successfully installed Powerlevel10k."
  fi
fi

mv .p10k.zsh $HOME/.p10k.zsh
mv .zshrc $HOME/.zshrc

# Setup up neovim
mkdir -p ~/.config
mv nvim ~/.config/nvim

echo -e "\nSetup is complete! Please restart your terminal or run 'exec zsh' to start using Zsh with Powerlevel10k and Oh My Zsh."
