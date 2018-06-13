# Installs Chocolatey and desired packages
# Package repository: https://chocolatey.org/packages
# Chocolatey help: https://chocolatey.org/docs/
# Command reference: https://chocolatey.org/docs/commands-reference
# NOTE: This must be run as an Administrator!

# Relaunch the script with administrator privileges
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host -ForegroundColor Red "Relaunching script with Administrator privileges..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
    Exit
}

# Install Chocolatey if it's not installed, otherwise update it.
if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor DarkGreen "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host -ForegroundColor Yellow "Chocolatey is already installed."
    Write-Host -ForegroundColor DarkGreen "Updating Chocolatey..."
    choco upgrade chocolatey -y
}

# Packages to install
# TODO: load this from a file
$packages = @(

    # Editors
    'notepadplusplus.install',  # Notepad++
    'visualstudiocode',         # Visual Studio Code
    # 'sublimetext3',           # Sublime Text 3
    'pycharm-community',

    # Browsers
    'googlechrome', # Google Chrome
    'firefox',      # Mozilla Firefox
    # 'chromium'    # Open-source version of Chrome

    # Runtimes/Programming Languages
    'jre8',     # Java SE Runtime Environment 8
    'jdk8',     # Java JDK 8
    'ruby',     # Ruby programming language
    'python3',  # Python programming language
    'python2',  # Old Python
    'golang',   # Go programming language
    'miktex.install',  # LaTeX

    # Utilities
    'ccleaner',         # CCleaner - Windows cleaning tool
    'sysinternals',     # Windows Sysinternals - troubleshooting utilities
    '7zip.install',     # 7-zip - file compression utility
    'procexp',          # Process Explorer
    'keepass.install',  # KeePass - password manager
    'greenshot',        # Light-weight screenshot tool
    'qbittorrent',
    'spotify',
    'revo.uninstaller',
    'cpu-z',
    'veracrypt',
    'ilspy',  # ILSpy is the open-source .NET assembly browser and decompiler
    'signal',  # Secure messaging

    # Commandline tools
    'hub',         # GitHub hub (https://github.com/github/hub)
    'curl',        # curl command
    'wget',        # wget command
    'youtube-dl',  # Small command-line program to download videos from YouTube.com and a few more sites
    'cmder',        # Terminal emulator
    
    # Viewers/Media
    'vlc',        # VLC media player
    'irfanview',  # IrfanView - Image viewer

    # Virtualization/Emulation
    'virtualbox',
    'vagrant',
    'docker',

    # Network tools
    'putty.install',  # PuTTY - Telnet/SSH client
    'filezilla',      # FileZilla - FTP/SFTP client
    'winscp',         # WinSCP - SFTP/SCP/FTP client
    'wireshark',      # Wireshark - Packet capture and analysis
    'nmap'
)

# Install the specified packages
ForEach ($package in $packages) {
    choco install $package --yes
}

# Install the Foxit Reader PDF reader
cinst foxitreader --yes --ia '/MERGETASKS="!desktopicon /COMPONENTS=*pdfviewer,*ffse,*installprint,*ffaddin,*ffspellcheck,!connectedpdf"'
& "C:\Program Files (x86)\Foxit Software\Foxit Reader\Foxit Cloud\unins000.exe" /silent

# Configure hub to be aliased from git command
Add-Content $PROFILE "`nSet-Alias git hub"
