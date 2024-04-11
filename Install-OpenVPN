function Install-OpenVPN {
    param (
        [boolean]$InstallOpenVPN = $true
    )

    if (-not $InstallOpenVPN) {
        Write-Host "Die Installation von OpenVPN wurde nicht gewünscht."
        Write-Output "$(Get-Date) - Die Installation von OpenVPN wurde nicht gewünscht." | Out-File -Append -FilePath $env:TEMP\log.txt
        return
    }

    # URL für den direkten Download von OpenVPN
    $DownloadUrl = "https://swupdate.openvpn.org/community/releases/OpenVPN-2.6.9-I001-amd64.msi"

    # Pfad für den Speicherort der heruntergeladenen Datei
    $InstallerPath = "$env:TEMP\OpenVPN-2.6.9-I001-amd64.msi"

    # Herunterladen von OpenVPN und Log schreiben
    Write-Host "Starte die Installation von OpenVPN..."
    Write-Output "$(Get-Date) - Starte die Installation von OpenVPN..." | Out-File -Append -FilePath $env:TEMP\log.txt
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath
    Write-Host "OpenVPN wurde erfolgreich installiert."
    Write-Output "$(Get-Date) - OpenVPN wurde erfolgreich installiert." | Out-File -Append -FilePath $env:TEMP\log.txt

    # Aufräumen
    Remove-Item $InstallerPath
}

Install-OpenVPN -InstallOpenVPN $true
