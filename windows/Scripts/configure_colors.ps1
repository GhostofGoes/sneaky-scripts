# TODO: script arguments (Look at Win10.ps1 and Win10.psm1)
$colorscheme = "OneHalfDark"
Write-Host -ForegroundColor DarkGreen "Changing color scheme to $colorscheme"
& "$(Split-Path -Parent $PSScriptRoot)\ColorTool\ColorTool.exe" --quiet --defaults $colorscheme
