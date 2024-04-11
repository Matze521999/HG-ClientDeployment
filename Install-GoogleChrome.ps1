function Install-GoogleChrome {
    param (
        [boolean]$InstallChrome = $true
    )

    $SoftwareName = "Google Chrome"

    if (-not $InstallChrome) {
        Write-Host "$SoftwareName wird nicht heruntergeladen, da die Installation nicht gewünscht ist."
        return
    }

    $Path = $env:TEMP
    $Installer = "chrome_installer.exe"
    $DownloadUrl = "http://dl.google.com/chrome/install/375.126/chrome_installer.exe"

    Write-Host "$SoftwareName wird heruntergeladen..."

    Invoke-WebRequest $DownloadUrl -OutFile "$Path\$Installer"
    Write-Host "$SoftwareName wurde erfolgreich heruntergeladen."

    Write-Host "$SoftwareName wird installiert..."

    if (Test-Path "$Path\$Installer") {
        Start-Process -FilePath "$Path\$Installer" -Args "/silent /install" -Verb RunAs -Wait
        Remove-Item "$Path\$Installer"
        Write-Host "$SoftwareName wurde erfolgreich installiert."
    }
    else {
        Write-Host "Fehler beim Herunterladen von $SoftwareName."
    }
}

Install-GoogleChrome -InstallChrome $true
