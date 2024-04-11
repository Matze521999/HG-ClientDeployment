if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; 
    exit 
}

$url = "https://raw.githubusercontent.com/Matze521999/HG-ClientDeployment/main/main.ps1"
$localPath = "$env:TEMP\main.ps1"
Invoke-WebRequest -Uri $url -OutFile $localPath
if (Test-Path $localPath) {
    & $localPath
}
