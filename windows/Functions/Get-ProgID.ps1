# Source: https://blogs.msdn.microsoft.com/powershell/2009/03/20/get-progid/
function Get-ProgID {
    #.Synopsis
    #   Gets all of the ProgIDs registered on a system
    #.Description
    #   Gets all ProgIDs registered on the system.  The ProgIDs returned can be used with New-Object -comObject
    #.Example
    #   Get-ProgID
    #.Example
    #   Get-ProgID | Where-Object { $_.ProgID -like "*Image*" }
    param()
    $paths = @("REGISTRY::HKEY_CLASSES_ROOT\CLSID")
    if ($env:Processor_Architecture -eq "amd64") {
        $paths+="REGISTRY::HKEY_CLASSES_ROOT\Wow6432Node\CLSID"
    }
    Get-ChildItem $paths -include VersionIndependentPROGID -recurse |   
    Select-Object @{
        Name='ProgID'
        Expression={$_.GetValue("")} 
    }, @{
        Name='32Bit'
        Expression={
            if ($env:Processor_Architecture -eq "amd64") {
                $_.PSPath.Contains("Wow6432Node")
            } else {
                $true
            }
        }
    }
}