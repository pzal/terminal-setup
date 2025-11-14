if [[ "$(uname)" == "Darwin" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

NEWLINE=$'\n'
RPROMPT="%F{024}%*%f"
PROMPT="${NEWLINE}%F{028}%B%n%b%f@%F{024}%B%m%b%f %F{240}%~%f ${NEWLINE}%F{024}%B>%b%f "


export EDITOR="nvim"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"

export PATH="$HOME/.local/bin:$PATH"

alias ls='ls --color'
alias glances='glances --theme-white'


# git
alias gits='git status'
alias gitp='git pull'
alias gitc='git checkout'
alias gitl='git log'


# Vi mode
# set -o vi
set -o emacs


# fzf for command history
export PATH="${PATH:+${PATH}:}${HOME}/.fzf/bin"
source <(fzf --zsh)


# Tab completion
# source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# bindkey              '^I' menu-select
# bindkey "$terminfo[kcbt]" menu-select
# bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
# bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char


# Zsh completion which is case-insensitive
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


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
  export SUMO_HOME="/opt/homebrew/opt/sumo/share/sumo"
  export PATH="$SUMO_HOME/bin:$PATH"
fi


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

# To fix `del` key in kitty and colors in tmux.
export TERM="xterm-256color"

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:'
if [[ "$(uname)" == "Darwin" ]]; then
  alias ls='gls --color'
fi

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# pnpm
export PNPM_HOME="/Users/pzal/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Devcontainers
source ~/dc_cli

export LANG=C.UTF-8


