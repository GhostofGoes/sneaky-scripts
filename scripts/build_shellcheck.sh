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

os_type

install_package() {
    echo "Installing package $i..."
    if [ $DEBIAN ] ; then
        sudo apt-get install -y -qq "$1"
    elif [ $FEDORA ] ; then
        sudo dnf install -y -qq "$1"
    elif [ $RHEL ] ; then
        sudo yum install -y -qq "$1"
    elif [ $SUSE ] ; then
        sudo zypper install -n -q -i install --auto-agree-with-licenses --force-resolution "$1"
    elif [ $FREEBSD ] ; then
        sudo pkg install "$i"
    fi
}

uninstall_package() {
    echo "Uninstalling package $i..."
    if [ $DEBIAN ] ; then
        sudo apt-get remove -y -qq "$1"
    elif [ $FEDORA ] ; then
        sudo dnf remove -y -qq "$1"
    elif [ $RHEL ] ; then
        sudo yum remove -y -qq "$1"
    elif [ $SUSE ] ; then
        sudo zypper -n -q -i rm "$1"
    elif [ $FREEBSD ] ; then
        sudo pkg delete "$i"
    fi
}

echo "Compiling and installing the latest version of ShellCheck..."
install_package "cabal-install"
cabal update
git clone https://github.com/koalaman/shellcheck.git
pushd ./shellcheck/ > /dev/null
cabal install --enable-tests > /dev/null
popd > /dev/null
uninstall_package "shellcheck"
rm -rf ./shellcheck/
echo "Finished installing ShellCheck"
