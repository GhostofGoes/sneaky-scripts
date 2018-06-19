#!/usr/bin/env bash

# Source: https://unix.stackexchange.com/a/41735
function os_type() {
case $(uname) in
  Linux )
     command -v dnf > /dev/null && { FEDORA=1; echo "dnf detected, definitely Fedora"; return; }
     command -v yum > /dev/null && { CENTOS=1; echo "yum detected, probably CentOS or RHEL"; return; }
     command -v zypper > /dev/null && { SUSE=1; echo "zypper detected, probably OpenSUSE"; return; }
     command -v apt-get > /dev/null && { DEBIAN=1; echo "apt-get detected, probably Debian"; return; }
     command -v pkg > /dev/null && { FREEBSD=1; echo "pkg detected, probably FreeBSD"; return; }
     ;;
  Darwin )
     DARWIN=1
     ;;
  * )
     # Handle AmgiaOS, CPM, and modified cable modems here.
     ;;
esac
}

function yum_vscode() {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
}


# Profile the OS
os_type

# TODO: configure proxy if set
# TODO: install vscode
# TODO: install golang

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
    'nano'      # Life not not complete without this
    'htop'      # Coloured and improved version of top
    'atop'      # Another resource monitoring tool
    'glances'   # Graphical resource monitoring tool
    'ncdu'      # Graphical view of directory sizes in terminal, using NCurses
)

if [ $DARWIN ]; then
    echo "I don't use OSX, sorry. If you put stuff here, please submit a PR or something."

elif [ $DEBIAN ]; then
    echo "Running setup for Debian or Debian-derivative. "
    # Update package cache, upgrade packages, and cleanup
    sudo apt-get update -y -qq
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    sudo apt-get autoremove -y

    sudo apt-get install -y -q python3-pip
    sudo apt-get install -y -q python-pip
    sudo apt-get install -y -q build-essential
    sudo apt-get install -y -q shellcheck

    # Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update -y -qq
    sudo apt-get install -y -q code # or code-insiders

    for i in "${useful_tools[@]}"; do
        sudo apt-get install -y -q "$i"
    done

    
    # TODO: base bashrc
    # TODO: detect WSL and do wsl bashrc
    # TODO: debian bashrc

elif [ $CENTOS ]; then
    echo "Running setup for CentOS. You masochist. "
    # Update package list and installed packages
    yum check-update -y -q
    sudo yum update -y -q

    # Add EPEL package repository
    sudo yum install -y -q epel-release

    # Install packages
    sudo yum install -y -q ShellCheck

    # Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
    yum_vscode
    yum check-update -y -q
    sudo yum install -y -q code

    # TODO: this will probably fail on many of these
    for i in "${useful_tools[@]}"; do
        sudo yum install -y -q "$i"
    done

    # TODO: base bashrc
    # TODO: centos bashrc

elif [ $FEDORA ]; then
    echo "Running setup for Fedora, the OS we all wish we could run if everyone wasn't Debian-obscessed. "
    dnf -y -q check-update
    sudo dnf -y -q upgrade

    # Install packages
    sudo dnf install -y -q ShellCheck

    # Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
    yum_vscode
    dnf -y -q check-update
    sudo dnf install -y -q code

    # TODO: this will probably fail on many of these
    for i in "${useful_tools[@]}"; do
        sudo dnf install -y -q "$i"
    done

    # TODO: base bashrc
    # TODO: fedora bashrc

elif [ $SUSE ]; then
    echo "Running setup for OpenSUSE. I don't use this yet, but might, so putting anything useful here for now."
    
    sudo zypper refresh
    sudo zypper in ShellCheck

    # Install Visual Studio Code (https://code.visualstudio.com/docs/setup/linux)
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
    sudo zypper refresh
    sudo zypper install code

    # TODO: update packages
    # TODO: install packages
    # TODO: bash bashrc

elif [ $FREEBSD ]; then
    echo "Running setup for FreeBSD. Same as OpenSUSE, I don't use this currently, but putting useful things here for now."
    # Update package lists, upgrade installed packages, and remove unneeded packages
    sudo pkg update
    sudo pkg upgrade
    # sudo portsnap fetch update
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

