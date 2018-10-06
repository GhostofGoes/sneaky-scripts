# NOTE: This must be run as an Administrator!

# Configurations
$colorscheme = "OneHalfDark"

# Relaunch the script with administrator privileges
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host -ForegroundColor Red "Relaunching script with Administrator privileges..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
    Exit
}

# OS Metadata
$wmi = Get-WmiObject -Class Win32_OperatingSystem
Write-Host -ForegroundColor DarkGreen "OS           : " ($wmi.Caption) ($wmi.OSArchitecture)
Write-Host -ForegroundColor DarkGreen "Version      : " ([System.Environment]::OSVersion.Version)
Write-Host -ForegroundColor DarkGreen "Install Date : " $wmi.ConvertToDateTime($wmi.InstallDate)

# Update PowerShell's built-in help modules
Write-Host -ForegroundColor DarkGreen "Updating PowerShell's help modules..."
Update-Help

Write-Host -ForegroundColor DarkGreen "Changing color scheme to $colorscheme"
.\ColorTool\ColorTool.exe --quiet --defaults $colorscheme

# Run Disassembler0's Win10/Server2016 setup script (https://github.com/Disassembler0/Win10-Initial-Setup-Script)
if ([System.Environment]::OSVersion.Version.Major -eq "10") {
    Write-Host -ForegroundColor DarkGreen "Windows version is 10. Running Disassembler0's setup script (Win10.ps1)"

    # Determine which config file to use, Desktop or Server
    $prod = $wmi.producttype
    if (($prod -eq 3) -or ($prod -eq 2)) {  # If Server or Domain Controller
        $presets_file = "WinServer2016-Config.preset"
    } else {
        $presets_file = "Win10-Config.preset"
    }

    # Run setup script with the appropriate preset file
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 -preset $presets_file

    Write-Host -ForegroundColor DarkGreen "Win10.ps1 finished"
    Write-Host -ForegroundColor Yellow "You must reboot before some of the configurations will be active."
}

# Install Chocolatey packages
# https://chocolatey.org/packages
powershell.exe -NoProfile -ExecutionPolicy Bypass -File choco.ps1

# Download the latest version of the script
# Write-Host "Downloading Win10.ps1..."
# $win10_url = "https://raw.githubusercontent.com/Disassembler0/Win10-Initial-Setup-Script/master/Win10.ps1"
# (New-Object System.Net.WebClient).DownloadString($win10_url, ".\Win10.ps1")
# Write-Host "Finished downloading Win10.ps1"

# Install Python packages
Get-Content ..\python-packages.txt | ForEach-Object {
    py -3 -m pip install --user --upgrade $_
}
