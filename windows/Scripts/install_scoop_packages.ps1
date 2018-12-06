if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor DarkGreen "scoop is not installed. Kicking that off for you now..."
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\install_scoop.ps1"
}

Write-Host -ForegroundColor DarkGreen "Installing 'aria2' package to speed up Scoop downloads and 'sudo' package to elevate admin rights for global packages"
scoop install aria2 sudo

# More packages of interest:
# Langs:    python ruby perl go dotnet dotnet-sdk haskell latex
# Network:  nmap wireshark hashcat
# VMs:      packer vagrant qemu busybox docker-compose docker aws
# DBs:      postgresql mysql rethinkdb
# Misc:     gnupg gitlab-runner dd msys2 cygwin autoit jetbrains-toolbox which speedfan
# CPP:      gcc gdb cppcheck cmake
$userPackages = @"
openssh ssh-copy-id telnet curl wget netcat youtube-dl
git git-lfs make gnupg aws concfg
7zip gzip unzip tar dos2unix grep sed less touch 
nano vim vimtutor jq time cloc shellcheck neofetch cowsay
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

