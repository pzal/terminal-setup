#!/usr/bin/env bash
sudo apt update
sudo apt install -y \
  vivid git curl build-essential neovim fzf ripgrep fd-find wget
wget -O /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz &&
  cd /tmp && tar xzvf nvim.tar.gz && sudo mv nvim-linux-x86_64 /opt/nvim && sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim &&
  rm -rf /tmp/nvim.tar.gz
