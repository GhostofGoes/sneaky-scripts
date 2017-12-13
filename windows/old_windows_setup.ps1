# Installs and configures tools and applications I use while working in Windows
# Flags for context, e.g work, school, portable, home
# 
# Need to check for Windows version. Generally it will be 7, 8.1, or 10.

# Thinking I have specify some sort of multi-dimensional arry, with download URL, name of the application, install flags, etc
# Loop over those

# Background Inteligent Transfer Service
# Import-Module BitsTransfer
# Start-BitsTransfer https://www.example.com/file C:/Local/Path/file

# Possible cool download status thing: http://stackoverflow.com/a/21422517
# DownloadFile("https://discordapp.com/api/download?platform=win", '%USERPROFILE%\Downloads\discord.exe')

# Discord setup
Write-Host "Downloading Discord"
(new-object System.Net.WebClient).DownloadFile("https://discordapp.com/api/download?platform=win",'\%USERPROFILE%\Downloads\discord.exe')
Write-Host "Installing Discord"
# this thing looks scary but OP as hell: http://psappdeploytoolkit.com/