# Remove useless aliases
Remove-Item alias:curl
Remove-Item alias:wget

# Provides same functionality as the Unix "which" command
function which($commandName)
{
    (Get-Command $commandName).Definition
}

# Shortens a filesystem path to singe-characters [used by prompt()].
function shorten-path([string] $path) { 
   $loc = $path.Replace($HOME, '~')
   # remove prefix for UNC paths 
   $loc = $loc -replace '^[^:]+::', '' 
   # make path shorter like tabs in Vim, 
   # handle paths starting with \\ and . correctly 
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2') 
}

# Shortens the path displayed at each line of the prompt.
# If in the root of a git repo, the Git status will be appended to the prompt.
function prompt {
    if(Test-Path .git) {
        # retrieve branch name
        $symbolicref = (git symbolic-ref HEAD)
        $branch = $symbolicref.substring($symbolicref.LastIndexOf("/") +1)

        # retrieve branch status
        $differences = (git diff-index HEAD --name-status)
        $git_mod_count = [regex]::matches($differences, 'M\s').count
        $git_add_count = [regex]::matches($differences, 'A\s').count
        $git_del_count = [regex]::matches($differences, 'D\s').count
        $branchData = " +$git_add_count ~$git_mod_count -$git_del_count"

        # write status string (-n : NoNewLine; -f : ForegroundColor)
        write-host 'GIT' -n -f White
        write-host ' {' -n -f Yellow
        write-host (shorten-path (pwd).Path) -n -f White
        
        write-host ' [' -n -f Yellow
        write-host $branch -n -f Cyan
        write-host $branchData -n -f Red
        write-host ']' -n -f Yellow
        
        write-host ">" -n -f Yellow
    }
    else {
        # write status string
        write-host 'PS' -n -f White
        write-host ' {' -n -f Yellow
        write-host (shorten-path (pwd).Path) -n -f White
        write-host ">" -n -f Yellow
    }

    return " "
}

# Chocolatey profile
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }
