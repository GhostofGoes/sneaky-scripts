# TODO: script arguments (Look at Win10.ps1 and Win10.psm1)

# NOTE: This must be run as an Administrator!
# Relaunch the script with administrator privileges
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host -ForegroundColor Yellow "Relaunching script with Administrator privileges..."
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
    Exit
}

# OS Metadata
$wmi = Get-WmiObject -Class Win32_OperatingSystem
Write-Host -ForegroundColor DarkGreen "OS           : " ($wmi.Caption) ($wmi.OSArchitecture)
Write-Host -ForegroundColor DarkGreen "Version      : " ([System.Environment]::OSVersion.Version)
Write-Host -ForegroundColor DarkGreen "Install Date : " $wmi.ConvertToDateTime($wmi.InstallDate)

# Run the individual setup/install scripts
$scriptDir = Resolve-Path "$PSScriptRoot\Scripts"
$scripts = @(
    "configure_profile",
    "configure_colors",
    "set_variables.ps1",
    "install_scoop",
    "install_scoop_packages",
    "install_pshazz",
    "install_chocolatey",
    "install_choco_packages"
    "install_python_packages"
)
foreach ($script in $scripts) {
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$scriptDir\$script.ps1"
}

# Update PowerShell's built-in help modules
Write-Host -ForegroundColor DarkGreen "Updating PowerShell's help modules..."
Update-Help

# TODO: Download the latest version of the script IF there's internet access AND it's newer
# Write-Host "Downloading Win10.ps1..."
# $win10_url = "https://raw.githubusercontent.com/Disassembler0/Win10-Initial-Setup-Script/master/Win10.ps1"
# (New-Object System.Net.WebClient).DownloadString($win10_url, ".\Win10.ps1")
# Write-Host "Finished downloading Win10.ps1"

# Run Disassembler0's Win10/Server2016 setup script (https://github.com/Disassembler0/Win10-Initial-Setup-Script)
if ([System.Environment]::OSVersion.Version.Major -eq "10") {
    Write-Host -ForegroundColor DarkGreen "Windows version is 10. Running Disassembler0's setup script (Win10.ps1)"

    # Determine which config file to use, Desktop or Server
    $prod = $wmi.producttype
    if (($prod -eq 3) -or ($prod -eq 2)) {  # If Server or Domain Controller
        $presetName = "WinServer2016-Config"
    } else {
        $presetName = "Win10-Config"
    }
    $presetsFile = "$PSScriptRoot\Configurations\$presetName.preset"

    # Run setup script with the appropriate preset file
    Write-Host -ForegroundColor DarkGreen "Loading Win10.ps1 presets from $presetsFile"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File Win10.ps1 -include Win10.psm1 -preset $presetsFile
    Write-Host -ForegroundColor DarkGreen "Win10.ps1 finished! (Presets were loaded from: $presetsFile)"
    Write-Host -ForegroundColor Yellow "You must reboot before some of the configurations will be active!"
}
