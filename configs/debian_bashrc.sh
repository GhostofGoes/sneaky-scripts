# Set colored terminal prompt as "hostname:current directory$ "
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ '

# Niceities
alias cd..="cd .."
alias rm="rm -i"  # Interactive mode delete
alias hs="cd ~/ && ls"
alias up="cd .."
alias home="cd ~/"
alias root="sudo su"
alias mkdir="mkdir -pv"  # Creates parent directories if needed
alias hist="history"
alias jobs="jobs -l"
alias path="echo -e ${PATH//:/\\n}"

# Power commands
alias shutdown="sudo shutdown -P now"
alias reboot="sudo shutdown -r now"

# Grep shorthands
alias grep="grep --color=auto"  # Colorize grep command output

# ls shorthands
alias l.="ls -d .* --color=auto"
alias ls="ls -C --color=auto"  # Make 'normal' ls nice with Columns and Colors
alias lm="ls -lhA --color=auto | more"  # For big directories
alias ll="ls -lh --color=auto"
alias la="ls -lhA --color=auto"
alias lar="ls -lhAR --color=auto | more"  # Recursive subdirectories, listed out
alias lcr="ls -CAR --color=auto | more"  # Recursive subdirectories, by column
alias lh="ls -lah --color=auto"

# Time
alias now="date +"%T""
alias nowtime=now
alias nowdate="date +\"%d-%m-%Y\""

# Networking
alias ports="netstat -tulanp"

# Updates
alias update="sudo apt-get -y update && sudo apt-get upgrade"
alias dist-update="sudo apt-get -y update && sudo apt-get dist-upgrade"
