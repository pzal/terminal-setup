
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="intheloop"

export UPDATE_ZSH_DAYS=30

plugins=(
    colored-man-pages
    docker
    docker-compose
)

source $ZSH/oh-my-zsh.sh
if [[ "$(uname)" == "Darwin" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


export EDITOR="nvim"
export VISUAL="$EDITOR"


# git
alias gits='git status'
alias gitp='git pull'
alias gitc='git checkout'
alias gitl='git log'


# History
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=$HISTSIZE


if [[ "$(uname)" == "Darwin" ]]; then
  ICLOUD_PATH=~/Library/Mobile\ Documents/com~apple~CloudDocs
  alias icloud='cd $ICLOUD_PATH'
fi

# Dependencies For installations (e.g. python's psycopg2, Pillow)
export PATH="/usr/local/opt/postgresql@12/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"

# Python venv
activate() {
    source ./.venv/bin/activate
    if [ -f .env ]; then
        set -a            
        source .env
        set +a
    fi
}

# Sumo stuff
if [[ "$(uname)" == "Darwin" ]]; then
  export SUMO_HOME="/opt/homebrew/Cellar/sumo/2.20.0/share/sumo"
  export PATH="$SUMO_HOME/bin:$PATH"
fi

# pipx stuff
export PATH="$PATH:$HOME/.local/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


if [[ "$(uname)" == "Darwin" ]]; then
  wattage() {
      info=$(ioreg -w 0 -f -r -c AppleSmartBattery)
      vol=$(echo $info | grep '"Voltage" = ' | grep -oE '[0-9]+')
      amp=$(echo $info | grep '"Amperage" = ' | grep -oE '[0-9]+')
      amp=$(bc <<< "if ($amp >= 2^63) $amp - 2^64 else $amp")
      wat="$(( (vol / 1000.0) * (amp / 1000.0) ))"
      printf "%.3f\n" $wat
  }
fi

# To fix `del` key in kitty.
export TERM=xterm

