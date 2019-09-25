# Sneaky Scripts
A collection of scripts I use for setting up my environment and doing day-to-day tasks.
Uses native platform tools, namely PowerShell on Windows, and BASH on Linux.

There are also various other useful things, like a thing to download "LinkedIn" slideshares, among other things. Poke around and enjoy :)


## Linux
```bash
# You'll need wget and unzip, unfortunatly. The other option, of course, is git.
wget https://github.com/GhostofGoes/sneaky-scripts/archive/master.zip
unzip master.zip
cd sneaky-scripts-master

# <<< EDIT THE SETTING VARIABLES IN THE SETUP SCRIPT >>>

# Run the setup script
bash setup.sh

# Run the configure script
# (NOTE: this will be done if INSTALL_CONFIGS is set to "true" in setup.sh)
bash configure.sh
```

## Windows
1. Download repo and unzip it
2. Open `windows/win10-Config.preset` in a text editor and set the configurations to what you want
3. Open a Administrator-level PowerShell prompt in the unzipped directory and run:
```powershell
.\windows\setup.ps1
```

## Platforms
* Windows: 10 (1604, 1704, 1709. 1803 TBD.)
* Ubuntu: 14, 16, 18
* Kali: 2017+
* CentOS/RHEL: 6+, 7+
* Fedora: 28+

### Untested, but potentially supported
* Debian
* OpenSUSE
* FreeBSD

## License
Licensed under the MIT licence. (See LICENSE file for details)
Feel free adapt for your own purposes, or just copy and go.
