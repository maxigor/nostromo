# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Shortcuts
alias eww="./eww/target/release/eww"
alias speedtest="speedtest-cli"
alias g="git"
alias h="history"
alias top="bpytop"
alias dl="cd /home/max/Downloads"
alias C="cd code"
alias c="cd code"
alias battery="cbatticon -d"
alias batterystats="upower -i /org/freedesktop/UPower/devices/battery_BAT0"
alias find="fd"
alias cat="bat"
alias myip="curl ifconfig.me"
alias kb="setxkbmap -model abnt2 -layout us -variant intl &"
alias logoff="bspc quit"
alias monitoroff="xset dpms force suspend"
alias ww="xprop | grep WM_CLASS"

# Disk Space Report
alias diskspace="ncdu"

# be nice
alias please=sudo
alias pls=sudo
alias hosts='sudo $EDITOR /etc/hosts'   # yes I occasionally 127.0.0.1 twitter.com ;)

# vim 
alias vim="nvim"
alias v="nvim"

# pacman and yay
alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs
alias parusua='paru -Sua --noconfirm'              # update only AUR pkgs (yay)
alias parusyu='paru -Syu --noconfirm'              # update standard pkgs and AUR pkgs (paru)
alias parusua='paru -Sua --noconfirm'             # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm'             # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # remove orphaned packages

# Changing "ls" to "exa"
alias ll='exa -al --color=always --icons --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias lsd='exa -l --color=always --group-directories-first'  # long format
alias llt='exa -aT --icons --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

# zsh move left and right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word


### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from the Arch User Repository: shell-color-scripts
colorscript random

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init zsh)"
