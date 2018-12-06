# Installs Chocolatey packages
# Package repository: https://chocolatey.org/packages
# Chocolatey help: https://chocolatey.org/docs/
# Command reference: https://chocolatey.org/docs/commands-reference
# NOTE: This must be run as an Administrator!

# Relaunch the script with administrator privileges
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host -ForegroundColor Yellow "Relaunching script with Administrator privileges..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
    Exit
}

# Check if Chocolatey is installed
if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor DarkGreen "Chocolatey is not installed. Kicking that off for you now..."
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\install_chocolatey.ps1"
}

# TODO: specify the package filepath as a script argument like Win10.ps1?
$chocoTools = "$(Split-Path -Parent $PSScriptRoot)\Configurations\choco_packages.txt"
$packages += Get-Content -Path $chocoTools -ErrorAction Stop | ForEach-Object { $_.Split("#")[0].Trim() } | Where-Object { $_ -ne "" }
Write-Host -ForegroundColor DarkGreen "Installing $($packages.length) Chocolatey packages..."
exit
ForEach ($package in $packages) {
    choco install $package --yes
}

# Install Foxit Reader PDF reader
# cinst foxitreader --yes --ia '/MERGETASKS="!desktopicon /COMPONENTS=*pdfviewer,*ffse,*installprint,*ffaddin,*ffspellcheck,!connectedpdf"'
# & "C:\Program Files (x86)\Foxit Software\Foxit Reader\Foxit Cloud\unins000.exe" /silent
