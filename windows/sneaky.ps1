# TODO: configure the .bat script to call this script



# Install Chocolatey (https://chocolatey.org/docs/installation)
Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))



# TODO: after lsxss is installed, run "bash" with -c and apply the bashrc and any other dotfiles.