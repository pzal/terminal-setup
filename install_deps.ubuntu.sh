#!/usr/bin/env bash
sudo apt update
sudo apt install -y \
  vivid git curl build-essential neovim fzf ripgrep fd-find wget tmux pipx nnn
pipx ensurepath
sudo pipx ensurepath --global

# Neovim
wget -O /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz &&
  cd /tmp && tar xzvf nvim.tar.gz && sudo mv nvim-linux-x86_64 /opt/nvim && sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim &&
  rm -rf /tmp/nvim.tar.gz

# Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -rf lazygit lazygit.tar.gz
