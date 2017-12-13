# Misc.

Chocolatey: https://chocolatey.org/
Package manager for Windows.

Create a package that runs the Win10.ps1 script.

# Misc. TODO
* PyPI upload
* More travis platforms
* Make note in readme about configuring Win10.ps1

# Initial loading

Publish releases with zipped versions of each OS's folders. So all I have to do is download the release .zip/.tar.gz file, uncompress it, and run the requisite install script (.ps1/.sh/.whatever). The releases zip: base files from top level, platform folders.

Platform specific install scripts could download and install Python, pip install dependancies, then run it.

# Shell customizations

## CMD
 open in useful directory, keyboard shortcut (CTRL+ALT+C), admin, text color

## Powershell
Open in useful directory, keyboard shortcut (CTRL+ALT+C), admin, text color

## Bash
Have base bash dotfiles that will work across platforms, then combine with the platform-specific dotfiles.

Use GNU Stow to instal the dotfiles?

## Bash for Windows
* Autoinstall and setup lsxss (the Windows Linux subsystem)
* Inject the .bashrc file
* Put a shortcut on taskbar, configured how I want for colors, fontsize, and such (have some parity with cmd/PowerShell except for colors)

## Bash on Ubuntu

## Bash on CentOS/RHEL




# Apps
Full list of apps to install and configure is in apps.md

## Chrome
* Flags
* Settings (synced?)
* Themes (synced?)

Configure both to pin to taskbar and start with the same settings.

https://github.com/Infinidat/infi.docopt_completion


# Settings
* Remote desktop / Remote assistance
* Performance
* System restore
* Crash dump
* Services
* Network settings: Disable IPv6, discover responder, file sharing
* Firewall
* Security settings


# Important areas
* Disable things on startup


# Resources

* Windows hardening powershell scripts
* Linux hardening bash scripts
* Configuration scripts/codes
