# Installs Chocolatey
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

# Install Chocolatey if it's not installed, otherwise update it.
if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor DarkGreen "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host -ForegroundColor Yellow "Chocolatey is already installed."
    Write-Host -ForegroundColor DarkGreen "Updating Chocolatey..."
    choco upgrade chocolatey -y
}
