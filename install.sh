#!/usr/bin/env bash

SUDO=""
if [ "$EUID" -ne 0 ]; then
  SUDO="sudo"
fi

# Make all package installations non-interactive
export DEBIAN_FRONTEND=noninteractive
export TZ=Europe/Warsaw

# Check if git is installed, install if not
if ! command -v git >/dev/null 2>&1; then
  echo "Git not found. Installing git..."
  if [[ "$(uname)" == "Darwin" ]]; then
    brew install git
  else
    $SUDO apt-get update && $SUDO apt-get install -y git
  fi

  # Verify git installation
  if ! command -v git >/dev/null 2>&1; then
    echo "Error: Git installation failed."
    exit 1
  else
    echo "Git installed successfully."
  fi
else
  echo "Git is already installed."
fi

# Version tracking
VERSION_FILE="$HOME/.terminal-setup-version"
REPO_URL="https://github.com/pzal/terminal-setup"

get_latest_commit() {
  git ls-remote "$REPO_URL" HEAD 2>/dev/null | cut -f1
}

echo "Checking for updates..."
LATEST_COMMIT=$(get_latest_commit)
if [ -n "$LATEST_COMMIT" ] && [ -f "$VERSION_FILE" ]; then
  CURRENT_VERSION=$(cat "$VERSION_FILE" 2>/dev/null)
  if [ "$CURRENT_VERSION" = "$LATEST_COMMIT" ]; then
    echo "Setup is already up to date (version: ${LATEST_COMMIT:0:7})"
    exit 0
  else
    echo "New version available. Running setup..."
  fi
else
  echo "Running setup..."
fi

# Handle existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
    echo "Existing .zshrc found. Backing up to .zshrc.old..."
    mv "$HOME/.zshrc" "$HOME/.zshrc.old"
fi

TEMP_DIR="/tmp/terminal-setup-$$"
echo "Cloning repository to $TEMP_DIR..."
if ! git clone "$REPO_URL" "$TEMP_DIR"; then
  echo "Failed to clone repository. Exiting."
  exit 1
fi

cd "$TEMP_DIR"

if [[ "$(uname)" == "Darwin" ]]; then
  ./install_deps.mac.sh
else
  ./install_deps.ubuntu.sh
fi

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

# fzf
rm -rf ~/.fzf || true
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin

# Tab completion
rm -rf ~/.zsh || true
mkdir -p ~/.zsh
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete

# Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh" # in lieu of restarting the shell
nvm install 22

# Devcontainer CLI
npm i --global @devcontainers/cli

# Claude
npm install -g @anthropic-ai/claude-code

# Configure Git
echo "Configuring Git..."
git config --global user.name "Piotr Zalewski"
git config --global user.email "mail@pzalewski.com"

# Copy new .zshrc
cp .zshrc $HOME/.zshrc
cp dc_cli $HOME/dc_cli

mkdir -p ~/.config

# Lazygit
rm -rf ~/.config/lazygit || true
cp -r lazygit ~/.config/lazygit

# Install formatters for nvim
pipx install isort
pipx install black
npm install --global @biomejs/biome
npm install --global prettier

# Setup up neovim
echo "Setting up neovim…"
rm -rf ~/.config/nvim || true
cp -r nvim ~/.config/nvim
nvim --headless "+Lazy! sync" +qa

# Setup up zed
echo "Setting up zed…"
rm -rf ~/.config/zed || true
cp -r zed ~/.config/zed

# Setup tmux
echo "Setting up tmux…"
rm -rf ~/.config/tmux || true
cp -r tmux_minimal ~/.config/tmux

# Setup kitty
echo "Setting up kitty…"
rm -rf ~/.config/kitty || true
cp -r kitty ~/.config/kitty

# Save version to track successful completion
if [ -n "$LATEST_COMMIT" ]; then
  echo "$LATEST_COMMIT" > "$VERSION_FILE"
  echo "Saved version: ${LATEST_COMMIT:0:7}"
fi

# Clean up temporary directory
echo "Cleaning up temporary files..."
cd "$HOME"
rm -rf "$TEMP_DIR"

echo -e "\nSetup is complete!"
