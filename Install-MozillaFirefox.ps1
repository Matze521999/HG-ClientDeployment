function Install-MozillaFirefox {
    param (
        [boolean]$InstallFirefox = $true
    )

    if (-not $InstallFirefox) {
        Write-Host "Die Installation von Mozilla Firefox wurde nicht gewünscht."
        Write-Output "$(Get-Date) - Die Installation von Mozilla Firefox wurde nicht gewünscht." | Out-File -Append -FilePath $env:TEMP\log.txt
        return
    }

    $Path = $env:TEMP;
    $Installer = "firefox_installer.exe";
    Invoke-WebRequest "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=de" -OutFile $Path\$Installer;
    Write-Host "Starte die Installation von Mozilla Firefox..."
    Write-Output "$(Get-Date) - Starte die Installation von Mozilla Firefox..." | Out-File -Append -FilePath $env:TEMP\log.txt
    Start-Process -FilePath $Path\$Installer -Args "/S" -Verb RunAs -Wait;
    Write-Host "Mozilla Firefox wurde erfolgreich installiert."
    Write-Output "$(Get-Date) - Mozilla Firefox wurde erfolgreich installiert." | Out-File -Append -FilePath $env:TEMP\log.txt
    Remove-Item $Path\$Installer
}

Install-MozillaFirefox -InstallFirefox $true
