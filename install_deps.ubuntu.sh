#!/usr/bin/env bash
SUDO=""
if [ "$EUID" -ne 0 ]; then
  SUDO="sudo"
fi

$SUDO apt update
$SUDO apt install -y \
  git curl build-essential neovim ripgrep fd-find wget tmux pipx unzip
pipx ensurepath
$SUDO pipx ensurepath --global

wget -O /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz &&
  cd /tmp && tar xzvf nvim.tar.gz && $SUDO mv nvim-linux-x86_64 /opt/nvim && $SUDO ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim &&
  rm -rf /tmp/nvim.tar.gz

# Fzf
wget https://github.com/junegunn/fzf/releases/download/v0.66.1/fzf-0.66.1-linux_amd64.tar.gz -O /tmp/fzf.tar.gz && tar -xzf /tmp/fzf.tar.gz -C /tmp
mv /tmp/fzf ~/.local/bin/

# Yazi
$SUDO apt install -y ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
wget https://github.com/sxyazi/yazi/releases/download/nightly/yazi-x86_64-unknown-linux-gnu.deb -O /tmp/yazi.deb
$SUDO apt install -y /tmp/yazi.deb

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
$SUDO install lazygit -D -t /usr/local/bin/
rm -rf lazygit lazygit.tar.gz
