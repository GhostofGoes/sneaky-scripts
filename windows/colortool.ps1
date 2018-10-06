# Configure the default color scheme for all Windows consoles
Write-Host -ForegroundColor DarkGreen "Downloading Windows Console ColorTool..."
$colorurl =  "https://github.com/Microsoft/console/releases/download/1810.02002/ColorTool.zip"
$colorscheme = "OneHalfDark"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest $colorurl -OutFile "ColorTool.zip"
Expand-Archive -Path "ColorTool.zip" -DestinationPath "ColorTool"
Write-Host -ForegroundColor DarkGreen "Changing color scheme to $colorscheme"
.\ColorTool\ColorTool.exe --quiet --defaults $colorscheme
Remove-Item -Path ColorTool.zip -Force

# Enable downloads for older TLS versions: https://stackoverflow.com/a/48030563/2214380
# [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
