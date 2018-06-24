#!/usr/bin/bash

# Source: https://unix.stackexchange.com/a/41735
function os_type() {
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

function yum_vscode() {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}


# Profile the OS
os_type

useful_tools=(
    'tcpdump'       # Capture network traffic
    'tshark'        # Command-line Wireshark
    'wireshark'     # The penultimate network analysis toolkit
    'wireshark-doc' # Documentation for the above
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

    'cloc'      # Count lines of code
    'nano'      # Life's not complete without Nano
    'htop'      # Coloured and improved version of top
    'atop'      # Another resource monitoring tool
    'glances'   # Graphical resource monitoring tool
    'ncdu'      # Graphical view of directory sizes in terminal, using NCurses
    'direnv'    # Shell environment switcher (https://direnv.net/)

    'unzip'
    'dos2unix'
    'tree'
    'git'
    'make'
    'wget'
    'curl'

    'jq'        # Command line JSON tool (https://stedolan.github.io/jq/)
    'ripgrep'   # Recursive grep/find thing (https://github.com/BurntSushi/ripgrep)
)


# TODO List:
# [ ] Configure proxy if set
# [ ] Configure vscode
# [ ] Configure PyCharm with desktop icon on Ubuntu
# [ ] Raspberry Pi-specific setup
# [ ] Configure Docker

# Programs to add
#   Docker
#   Git LFS
#   Firefox
#   Chrome/Chromium
#   golang
#   PyCharm

# Features
#   Detect Ubuntu

# TODO: Flag for non-desktop runs to not include graphical programs like VScode
# TODO: Install bashrcs!


if [ $DARWIN ]; then
    echo "I don't use OSX, sorry. If you put stuff here, please submit a PR or something."

elif [ $DEBIAN ]; then
    echo "Running setup for Debian or some impure Debian-derivative, like Ubuntu or Kali. "
    # Update package cache, upgrade packages, and cleanup
    sudo apt-get update -y -qq
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    sudo apt-get autoremove -y

    sudo apt-get install -y -q python3-pip
    sudo apt-get install -y -q python-pip
    sudo apt-get install -y -q build-essential
    sudo apt-get install -y -q shellcheck
    sudo apt-get install -y -q net-tools
    sudo apt-get install -y -q geoip-bin

    # Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update -y -qq
    sudo apt-get install -y -q code # or code-insiders

    for i in "${useful_tools[@]}"; do
        sudo apt-get install -y -q "$i"
    done

    sudo apt-get clean

    # TODO: base bashrc
    # TODO: detect WSL and do wsl bashrc
    # TODO: debian bashrc

elif [ $RHEL ]; then
    echo "Running setup for RHEL/CentOS. I'd put something witty here, but that'd be against corporate policy."
    # Update package list and installed packages
    yum check-update -y -q
    sudo yum update -y -q

    # Add EPEL package repository
    sudo yum install -y -q epel-release

    # Install packages
    sudo yum install -y -q ShellCheck
    sudo yum install -y -q geoip  # geoiplookup 

    # Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
    yum_vscode
    yum check-update -y -q
    sudo yum install -y -q code

    # TODO: this will probably fail on many of these
    for i in "${useful_tools[@]}"; do
        sudo yum install -y -q "$i"
    done

    # TODO: base bashrc
    # TODO: RHEL bashrc

elif [ $FEDORA ]; then
    echo "Running setup for Fedora, the OS we all wish we could run if everyone wasn't Debian-obscessed."
    dnf check-update -y -q 
    sudo dnf upgrade -y -q 

    # Install packages
    sudo dnf install -y -q ShellCheck

    # Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
    yum_vscode
    dnf check-update -y -q
    sudo dnf install -y -q code
    sudo dnf install -y -q geoip

    # TODO: this will probably fail on many of these
    for i in "${useful_tools[@]}"; do
        sudo dnf install -y -q "$i"
    done

    # TODO: base bashrc
    # TODO: fedora bashrc

elif [ $SUSE ]; then
    echo "Running setup for OpenSUSE. Let's do science! That's what OpenSUSE is for, right? ...right?"
    ## NOTE: I don't use this yet, but might, so putting anything useful here for now
    
    # Refresh package cache and update packages
    sudo zypper refresh
    sudo zypper update
    sudo zypper dist-upgrade

    # Install packages
    sudo zypper in ShellCheck

    # Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
    sudo zypper refresh
    sudo zypper install code

    # TODO: this will probably fail on many of these
    for i in "${useful_tools[@]}"; do
        sudo zypper install "$i"
    done

    sudo zypper clean

    # TODO: bash bashrc

elif [ $FREEBSD ]; then
    echo "Running setup for FreeBSD. This is probably a firewall or router. You poor soul."
    ## NOTE: I don't use this currently, but putting useful things here for now

    # Update package lists, upgrade installed packages, and remove unneeded packages
    sudo pkg update
    sudo pkg upgrade

    # TODO: this will probably fail on many of these
    for i in "${useful_tools[@]}"; do
        sudo pkg install "$i"
    done


    sudo pkg autoremove
fi

if ! python3 -m pip; then
    echo "Python 3 pip isn't installed. Installing..."
    python3 -m ensurepip
fi

if ! python -m pip; then
    echo "Python 2 pip isn't installed. Installing..."
    python -m ensurepip
fi

# Install Python packages
echo "Installing Python 3 packages..."
while read -r py_package; do
    python3 -m pip install --user "$py_package"
done < ../python-packages.txt

