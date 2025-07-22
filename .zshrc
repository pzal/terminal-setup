if [[ "$(uname)" == "Darwin" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

NEWLINE=$'\n'
RPROMPT="%F{024}%*%f"
PROMPT="${NEWLINE}%F{028}%B%n%b%f@%F{024}%B%m%b%f %F{240}%~%f ${NEWLINE}%F{024}%B>%b%f "


export EDITOR="nvim"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"


alias ls='ls --color'


# git
alias gits='git status'
alias gitp='git pull'
alias gitc='git checkout'
alias gitl='git log'


# Vi mode
set -o vi


# fzf for command history
export PATH="${PATH:+${PATH}:}${HOME}/.fzf/bin"
source <(fzf --zsh)


# Tab completion
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select
bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
bindkey -M menuselect '^M' .accept-line
zstyle ':autocomplete:*' delay 600  # Essentially wait until a manual <tab>


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

# To fix `del` key in kitty and colors in tmux.
export TERM="xterm-256color"

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:'
if [[ "$(uname)" == "Darwin" ]]; then
  alias ls='gls --color'
fi

# nnn file manager with cd-on-quit
BLK="0B" CHR="0B" DIR="13" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
n ()
{
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn -A "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}


# pnpm
export PNPM_HOME="/Users/pzal/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Devcontainers

alias dcup='devcontainer up --remove-existing-container --workspace-folder .'
alias dcb='devcontainer build --workspace-folder .'

_dc_init () {
    WORKSPACE_FOLDER=$(pwd)
    CONTAINER_ID=$(docker ps -q --filter "label=devcontainer.local_folder=${WORKSPACE_FOLDER}")
    
    CONTAINER_HOME=$(docker exec $CONTAINER_ID sh -c 'echo $HOME')

    if [ -d "$HOME/.ssh" ]; then
        docker cp "$HOME/.ssh" "$CONTAINER_ID:$CONTAINER_HOME/"
    fi

    if [ -d "$HOME/.claude" ]; then
        docker cp "$HOME/.claude" "$CONTAINER_ID:$CONTAINER_HOME/"
        docker cp "$HOME/.claude.json" "$CONTAINER_ID:$CONTAINER_HOME/.claude.json"
    fi
}

dcef () {
    _dc_init
    docker exec $CONTAINER_ID bash -c "git config --global --add safe.directory \$(pwd) && curl -fsSL https://raw.githubusercontent.com/pzal/terminal-setup/main/install.sh | bash"
    docker exec --detach-keys='ctrl-q,q' -ti $CONTAINER_ID zsh
}

dcem () {
    _dc_init
    docker exec $CONTAINER_ID bash -c "sudo apt update && sudo apt install -y tmux neovim"
    docker exec --detach-keys='ctrl-q,q' -ti $CONTAINER_ID zsh
}

dce () {
    _dc_init
    docker exec --detach-keys='ctrl-q,q' -ti $CONTAINER_ID "$@"
}

export LANG=C.UTF-8

