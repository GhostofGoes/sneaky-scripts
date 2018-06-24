A collection of scripts I use for setting up my environment and doing day-to-day tasks.
Uses native platform tools, namely PowerShell on Windows, and BASH on Linux.

If you want to download "LinkedIn" slideshares, there's also a thing for that.

# Linux

## If you just want to get the configurations
```bash
chmod +x ./configure.sh
./configure.sh
```

# Full setup, including install of various tools and packages
```bash
# You'll need wget and unzip, unfortunatly. The other option, of course, is git.
wget https://github.com/GhostofGoes/sneaky-scripts/archive/master.zip
unzip master.zip
cd sneaky-scripts-master
chmod +x ./setup.sh
./setup.sh
```

# Windows
* Download repo and unzip it
* Open `windows/win10-Config.preset` in a text editor and set the configurations to what you want
* Open a Administrator-level PowerShell prompt in the unzipped directory and run:
```powershell
.\windows\setup.ps1
```

# Platforms
* Windows: 10 (1604, 1704, 1709. 1803 TBD.)
* Ubuntu: 14, 16, 18
* Kali: 2017+
* CentOS/RHEL: 6+, 7+
* Fedora: 28+

## Untested, but potentially supported
* Debian
* OpenSUSE
* FreeBSD

# License
Licensed under the MIT licence. (See LICENSE file for details)
Feel free adapt for your own purposes, or just copy and go.
