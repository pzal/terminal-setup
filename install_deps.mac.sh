#!/usr/bin/env bash
xcode-select --install
brew install \
  jesseduffield/lazygit/lazygit curl ripgrep fd coreutils neovim tmux pipx unzip
# Yazi
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font
pipx ensurepath
sudo pipx ensurepath --global
