# TODO: specify the package filepath as a script argument like Win10.ps1?

Write-Host -ForegroundColor DarkGreen "Upgrading pip..."
py -3 -m pip install -U pip
$packagesFile = Resolve-Path "$PSScriptRoot\..\..\python-packages.txt"
$packages += Get-Content -Path $packagesFile -ErrorAction Stop | ForEach-Object { $_.Split("#")[0].Trim() } | Where-Object { $_ -ne "" }
Write-Host -ForegroundColor DarkGreen "Installing $($packages.length) Python packages from $packagesFile"
ForEach ($package in $packages) {
    py -3 -m pip install --user --upgrade $package
}
