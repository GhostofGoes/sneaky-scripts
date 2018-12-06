if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor DarkGreen "scoop is not installed. Kicking that off for you now..."
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\install_scoop.ps1"
}

if (!(Get-Command pshazz -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor DarkGreen "Installing pshazz..."
    scoop install pshazz
} else {
    Write-Host -ForegroundColor Yellow "pshazz is already installed"
}
