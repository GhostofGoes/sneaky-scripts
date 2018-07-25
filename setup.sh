#!/usr/bin/env bash

# Source: https://unix.stackexchange.com/a/41735
os_type() {
case $(uname) in
  Linux )
     command -v cmd.exe > /dev/null && { WSL=1; echo "Windows Subsystem for Linux detected"; }
     command -v apt-get > /dev/null && { DEBIAN=1; echo "apt-get detected, probably Debian"; return; }
     command -v dnf > /dev/null && { FEDORA=1; echo "dnf detected, definitely Fedora"; return; }
     command -v yum > /dev/null && { RHEL=1; echo "yum detected, probably RHEL or CentOS"; return; }
     command -v zypper > /dev/null && { SUSE=1; echo "zypper detected, probably OpenSUSE"; return; }
     command -v pkg > /dev/null && { FREEBSD=1; echo "pkg detected, probably FreeBSD"; return; }
     ;;
  Darwin )
     DARWIN=1
     ;;
  * )
     ;;
esac
}

# Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
install_vscode() {
    echo "Installing VScode..."
    if [ $DEBIAN ] ; then
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt-get update -y -qq
        sudo apt-get install -y -qq code # Change this to "code-insiders" if you like to live on the bleeding edge
    elif [ "$(command -v rpm > /dev/null)" -eq 0 ] ; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        if [ ! $SUSE ] ; then
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        else
            sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
        fi
        if [ $SUSE ] ; then
            sudo zypper -n -q -i refresh
            sudo zypper -n -q -i install -l code
        elif [ $FEDORA ] ; then
            dnf check-update -y -qq
            sudo dnf install -y -qq code
        else
            yum check-update -y -qq
            sudo yum install -y -qq code
        fi
    else
        echo "Failed to install VScode: unknown platform" && return
    fi
    echo "Finished installing VScode"
}

yum_vscode() {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}

useful_tools=(
    'tcpdump'       # Capture network traffic
    'tshark'        # Command-line Wireshark

    'snmp'          # snmpwalk and friends
    'snmp-mibs-downloader'  # SNMP MIBS
    'nmap'          # Network mapping/scanning

    'ipcalc'      # IP address/subnet calculator
    'mtr'         # Network diagnostic tool, basically an advanced traceroute
    'traceroute'  # The traditional traceroute tool
    'iftop'       # top for network interfaces, gives you nice network statistics and other infos
    'iptraf'      # Interactive Colorful IP LAN Monitor
    'nethogs'     # Net top tool grouping bandwidth per process
    'whois'       # Who are you? (Yeah, this isn't installed by default...)
    'arping'      # ARP ping

    'cloc'      # Count lines of code
    'nano'      # Life's not complete without Nano
    'htop'      # Coloured and improved version of top
    'atop'      # Another resource monitoring tool
    'glances'   # Graphical resource monitoring tool
    'ncdu'      # Graphical view of directory sizes in terminal, using NCurses
    'direnv'    # Shell environment switcher (https://direnv.net/)
    
    'locate'
    'xclip'     # Pipes input to the clipboard
    'unzip'
    'zip'
    'lsof'
    'strace'    # Useful for debugging
    'dos2unix'  # Convert /r/n (Windows) file endings to /n (Linux)
    'tree'
    'git'       # Git version control system
    'make'
    'wget'
    'curl'
    'grep'      # Text search
    'sed'       # Stream editor
    'ssh'       # Debian on WSL doesn't include SSH by default

    'cowsay'    # Moooo
    'neofetch'  # Nice pretty CLI output of system information

    'jq'        # Command line JSON tool (https://stedolan.github.io/jq/)
    'ripgrep'   # Recursive grep/find thing (https://github.com/BurntSushi/ripgrep)
    'cppcheck'  # C++ static code analyzer (https://github.com/danmar/cppcheck) 
)

gui_tools=(
    'wireshark'     # The penultimate network analysis toolkit
    'wireshark-doc' # Documentation for the above
    'zenmap'
    'terminator'
)

apt_packages=(
    'python3-pip'
    'python-pip'
    'build-essential'
    'shellcheck'
    'net-tools'  # ipconfig, arp, etc.
    'geoip-bin'
    'gddrescue'  # ddrescue
    'apt-transport-https'
    'ca-certificates'
    'software-properties-common'  # Needed for Docker
)


# TODO List:
# [ ] Configure proxy if set
# [ ] Configure vscode
# [ ] Configure PyCharm with desktop icon on Ubuntu (make sure .desktop file is configured on Ubuntu/Kali)
# [ ] Raspberry Pi-specific setup
# [ ] Configure Docker
# [ ] Timezone configuration

# Features
#   Detect Ubuntu
#   Detect pacman (Arch, MSYS)

# TODO: Flag for non-desktop runs to not include graphical programs like VScode
# TODO: cleanup the output and messages
# TODO: JSON/txt file with apps?

# TODO: only install common programs if they're not already installed
#   ssh, locate, zip, unzip, curl, wget, nano, grep, sed

# Graphical apps: 
#   Gedit, PyCharm, browsers, DB Browser for SQL, Remmina (RDP client)
#   Private Internet Access (PIA), KeePass, Steam, Spotify, VLC player, TexWorks/TexStudio, Dropbox
#   VirtualBox, VMware, Discord

# Settings + Flags + Themes + Plugins/Extensions for graphical apps
#   Chrome, Firefox, PyCharm, VScode

# CLI/etc apps:
#   LaTeX, Vagrant, golang

# TODO:
# ~/.curlrc
# ~/.wgetrc
# Terminator config (Example: https://gist.github.com/starenka/1709840)

# Script settings (TODO)
# Load from a default named file, and/or file specified as argument
TZ="Amercia/Denver"  # Pro tip: if you don't live in Arizona, don't use America/Phoenix. There be dragons.
INSTALL_PY3_PACKAGES=true
INSTALL_PY2_PACKAGES=false
INSTALL_VSCODE=true
INSTALL_DOCKER=true
INSTALL_GITLFS=true

# Profile the OS
os_type

if [ $DARWIN ]; then
    echo "I don't use OSX, sorry. If you put stuff here, please submit a PR or something."

elif [ $DEBIAN ]; then
    echo "Running setup for Debian or some impure Debian-derivative, like Ubuntu or Kali. "
    # Update package cache, upgrade packages, and cleanup
    echo "Refreshing apt package cache and updating existing packages..."
    sudo apt-get update -y -qq
    sudo apt-get upgrade -y -qq
    sudo apt-get dist-upgrade -y -qq
    sudo apt-get autoremove -y -qq

    echo "Installing apt-specific packages..."
    for i in "${apt_packages[@]}"; do
        sudo apt-get install -y -qq "$i"
    done

    # TODO: generalize this and just swap out the package manager? (the 'p' thing I saw maybe?)
    echo "Installing various useful tools..."
    for i in "${useful_tools[@]}"; do
        sudo apt-get install -y -qq "$i"
    done
    
    if [ ! $WSL ]; then
        echo "Installing graphical tools..."
        for i in "${gui_tools[@]}"; do
            sudo apt-get install -y -qq "$i"
        done
        sudo apt-get install -y -qq gedit
    fi

    sudo apt-get -y -qq clean

elif [ $RHEL ]; then
    echo "Running setup for RHEL/CentOS. I'd put something witty here, but that'd be against corporate policy."
    # Update package list and installed packages
    echo "Refreshing yum package cache and updating existing packages..."
    yum check-update -y -qq
    sudo yum update -y -qq

    # Add EPEL package repository
    sudo yum install -y -qq epel-release

    # Install packages
    sudo yum install -y -qq ShellCheck
    sudo yum install -y -qq geoip  # geoiplookup 

    # TODO: this will probably fail on many of these
    echo "Installing various useful tools..."
    for i in "${useful_tools[@]}"; do
        sudo yum install -y -qq "$i"
    done

    if [ ! $WSL ]; then
        echo "Installing graphical tools..."
        for i in "${gui_tools[@]}"; do
            sudo yum install -y -qq "$i"
        done
    fi

elif [ $FEDORA ]; then
    echo "Running setup for Fedora, the OS we all wish we could run if everyone wasn't Debian-obscessed."
    echo "Refreshing dnf package cache and updating existing packages..."
    dnf check-update -y -qq
    sudo dnf upgrade -y -qq 

    # Install packages
    sudo dnf install -y -qq ShellCheck
    sudo dnf install -y -qq geoip

    # Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
    if [ ! $WSL ]; then
        echo "Installing VScode..."
        yum_vscode
        dnf check-update -y -qq
        sudo dnf install -y -qq code
    fi

    # TODO: this will probably fail on many of these
    echo "Installing various useful tools..."
    for i in "${useful_tools[@]}"; do
        sudo dnf install -y -qq "$i"
    done

    if [ ! $WSL ]; then
        echo "Installing graphical tools..."
        for i in "${gui_tools[@]}"; do
            sudo dnf install -y -qq "$i"
        done
    fi

elif [ $SUSE ]; then
    echo "Running setup for OpenSUSE. Let's do science! That's what OpenSUSE is for, right? ...right?"
    ## NOTE: I don't use this yet, but might, so putting anything useful here for now
    
    # Refresh package cache and update packages
    echo "Refreshing zypper package cache and updating existing packages..."
    sudo zypper --non-interactive --quiet --ignore-unknown refresh
    sudo zypper -n -q -i update
    sudo zypper -n -q -i dist-upgrade

    # Install packages
    sudo zypper -n -q -i install --auto-agree-with-licenses --recommends --force-resolution ShellCheck
    sudo zypper -n -i install -l --recommends --force-resolution python3

    # TODO: this will probably fail on many of these
    echo "Installing various useful tools..."
    for i in "${useful_tools[@]}"; do
        sudo zypper -n -q -i install -l --recommends --force-resolution "$i"
    done

    if [ ! $WSL ]; then
        echo "Installing graphical tools..."
        for i in "${gui_tools[@]}"; do
            sudo zypper -n -q -i install -l --recommends --force-resolution "$i"
        done
    fi
    sudo zypper -n -q -i clean

elif [ $FREEBSD ]; then
    echo "Running setup for FreeBSD. This is probably a firewall or router. You poor soul."
    ## NOTE: I don't use this currently, but putting useful things here for now

    # Update package lists, upgrade installed packages, and remove unneeded packages
    sudo pkg update
    sudo pkg upgrade

    # TODO: this will probably fail on many of these
    echo "Installing various useful tools..."
    for i in "${useful_tools[@]}"; do
        sudo pkg install "$i"
    done
    if [ ! $WSL ]; then
        echo "Installing graphical tools..."
        for i in "${gui_tools[@]}"; do
            sudo pkg install "$i"
        done
    fi
    sudo pkg autoremove
fi

# Create .ssh directory if it doesn't exist
echo "Configuring SSH..."
mkdir -pv ~/.ssh/
if [ $WSL ] ; then
    WINUSER=$( whoami.exe | cut -d '\' -f2 | tr -d '[:space:]')
    if [ -d "/mnt/c" ]; then
        mkdir -pv "/mnt/c/Users/{$WINUSER}/.ssh/"
    fi
fi

# Install Python packages
if [ $INSTALL_PY3_PACKAGES ] ; then
    echo "Installing Python 3 packages..."
    if ! python3 -m pip; then
    echo "Python 3 pip isn't installed. Installing..."
    python3 -m ensurepip
    fi
    while read -r py_package; do
        python3 -m pip install --user "$py_package"
    done < ../python-packages.txt
fi
if [ $INSTALL_PY2_PACKAGES ] ; then
    echo "Installing Python 2 packages..."
    if ! python -m pip; then
        echo "Python 2 pip isn't installed. Installing..."
        python -m ensurepip
    fi
    while read -r py_package; do
        python -m pip install --user "$py_package"
    done < ../python-packages.txt
fi

# Install Docker
if [ $INSTALL_DOCKER ] && [ ! $WSL ] ; then
    echo "Installing Docker..."
    curl -fsSL get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker "$USER"
fi

# Install git-lfs
# TODO: method to determine latest version
if [ $INSTALL_GITLFS ] ; then
    LFSVERSION="2.4.2"
    echo "Installing git-lfs $LFSVERSION..."
    wget https://github.com/git-lfs/git-lfs/releases/download/v"$LFSVERSION"/git-lfs-linux-amd64-"$LFSVERSION".tar.gz
    tar -C ./ -xf git-lfs-linux-amd64-"$LFSVERSION".tar.gz
    rm -f git-lfs-linux-amd64-"$LFSVERSION".tar.gz
    pushd ./git-lfs-"$LFSVERSION" > /dev/null
    sudo ./install.sh
    popd > /dev/null
    rm -rf "./git-lfs-$LFSVERSION/"
fi

# Install Visual Studio Code. Skip if we're in WSL.
if [ $INSTALL_VSCODE ] && [ ! $WSL ] && [ "$(command -v code > /dev/null)" -eq 1 ] ; then
    install_vscode
fi

# Update the locate database
sudo updatedb

# Install configs
source ./configure.sh
