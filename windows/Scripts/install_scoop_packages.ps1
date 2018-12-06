if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor DarkGreen "scoop is not installed. Kicking that off for you now..."
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\install_scoop.ps1"
}

Write-Host -ForegroundColor DarkGreen "Installing 'aria2' package to speed up Scoop downloads and 'sudo' package to elevate admin rights for global packages"
scoop install aria2 sudo

# More packages of interest:
# Langs:    python ruby perl go dotnet dotnet-sdk haskell latex pypy2
# Network:  nmap wireshark hashcat putty
# VMs:      packer vagrant qemu busybox docker-compose docker aws
# DBs:      postgresql mysql rethinkdb
# Fancy:    posh-git
# Misc:     gnupg gitlab-runner dd msys2 cygwin autoit  which speedfan youtube-dl-gui
# Dev:      postman gcc gdb cppcheck cmake plantuml
# Editors:  jetbrains-toolbox pycharm vscode atom notepadplusplus notepad2 vimtutor vim
$userPackages = @"
openssh ssh-copy-id telnet curl wget netcat youtube-dl
git git-lfs make gnupg aws concfg
7zip gzip unzip tar dos2unix grep sed less touch 
nano jq time cloc shellcheck neofetch cowsay
"@
$separator = " ","`n","`r`n"
$userPackages = $userPackages.Split($separator, [System.StringSplitOptions]::RemoveEmptyEntries)
if ($userPackages.Length -gt 0) {
    Write-Host -ForegroundColor DarkGreen "Installing Userland scoop packages:`n$userPackages"
    scoop install $userPackages
}

$globalPackages = ""
if ($globalPackages.Length -gt 0) {
    Write-Host -ForegroundColor DarkGreen "Installing Global scoop packages:`n$globalPackages"
    sudo scoop install "$globalPackages"
}

