#!/usr/bin/env bash
# Loads configurations into their proper places

if [ ! -d "./configs" ] ; then
    echo "Could not find configs. This script must be run in the root sneaky-scripts directory."
    exit 1
fi

cat ./configs/bash_aliases >> ~/.bash_aliases
cat ./configs/bash_profile >> ~/.bash_profile
cat ./configs/profile >> ~/.profile
cat ./configs/bashrc >> ~/.bashrc

cat ./configs/ssh_config >> ~/.ssh/config
chmod 644 ~/.ssh/config

if [ -f ~/.gitconfig ]; then
    sudo chown "$USER":"$USER" ~/.gitconfig
fi
cat ./configs/gitconfig >> ~/.gitconfig

if [ $WSL ] ; then
    echo "Installing SSH key for WSL..."
    if [ -d "/mnt/c" ] ; then
        WINHOME="/mnt/c/Users/${WINUSER}"
    elif [ -d "/c" ] ; then
        WINHOME="/c/Users/${WINUSER}"
    fi
    cat ./configs/ssh_config >> "${WINHOME}/.ssh/config"
    chmod 644 "${WINHOME}/.ssh/config"
fi

if [ $DEBIAN ] && [ ! $WSL ] ; then
    echo "Attempting to disable lock screen... (Failures are ignored)"
    gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true' 2> /dev/null || true
fi
