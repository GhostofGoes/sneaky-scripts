# TODO: make source profile path configurable with an argument
# TODO: move to commands? ("Configure-PowerShellProfile" or something)
if (!(Test-Path $profile.CurrentUserAllHosts)) {
    Write-Host -ForegroundColor DarkGreen "Copying profile to profile.CurrentUserAllHosts ($profile.CurrentUserAllHosts)"
    Copy-Item -Path "$(Split-Path -Parent $PSScriptRoot)\Configurations\profile.ps1" -Destination $profile.CurrentUserAllHosts
} else {
    Write-Warning "There is already a profile at $profile.CurrentUserAllHosts"
    Write-Host -ForegroundColor DarkGreen "Going to ensure a few basic configurations are set in the existing profile..."
    $currentProfile = (Get-Content $profile.CurrentUserAllHosts)
    $configurationValues = @(
        "Remove-Item alias:curl",
        "Remove-Item alias:wget"
    )
    # TODO: make this more generalized and extensible
    #       Have a file with the content, like current profile.ps1, seperated by some seperator
    #       Then iterate through and do the search/add operation on the logical components
    ForEach ($config in $configurationValues) {
        if (!($currentProfile.Contains($config))) {
            Write-Host -ForegroundColor DarkGreen "Adding configuration: $config"
            Add-Content -Path $profile.CurrentUserAllHosts -Value "`n$config" -NoNewline
        }
        
    }
}
# (Get-Content $profile.CurrentUserAllHosts).replace($config, $config) | Set-Content $profile.CurrentUserAllHosts
