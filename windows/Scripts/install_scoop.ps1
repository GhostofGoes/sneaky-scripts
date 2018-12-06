# Install Scoop (https://scoop.sh/)
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host -ForegroundColor DarkGreen "Installing Scoop..."
    Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
    Write-Host -ForegroundColor DarkGreen "Adding the 'extras' Scoop bucket..."
    scoop bucket add extras
} else {
    Write-Host -ForegroundColor Yellow "Scoop is already installed, running 'scoop update' instead"
    scoop update
}
