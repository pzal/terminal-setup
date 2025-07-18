#!/usr/bin/env bash
xcode-select --install
brew install \
  jesseduffield/lazygit/lazygit curl ripgrep fd coreutils neovim tmux pipx nnn unzip
pipx ensurepath
sudo pipx ensurepath --global
