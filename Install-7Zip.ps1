function Install-7Zip {
    param (
        [boolean]$Install7Zip = $true
    )

    $SoftwareName = "7-Zip"

    if (-not $Install7Zip) {
        Write-Host "$SoftwareName wird nicht heruntergeladen, da die Installation nicht gewünscht ist."
        return
    }

    $Path = $env:TEMP
    $Installer = "7z.exe"
    $DownloadUrl = "https://7-zip.org/a/7z2301-x64.exe"

    Write-Host "$SoftwareName wird heruntergeladen..."

    Invoke-WebRequest $DownloadUrl -OutFile "$Path\$Installer"
    Write-Host "$SoftwareName wurde erfolgreich heruntergeladen."

    Write-Host "$SoftwareName wird installiert..."

    if (Test-Path "$Path\$Installer") {
        Start-Process -FilePath "$Path\$Installer" -ArgumentList "/S" -Wait
        Remove-Item "$Path\$Installer"
        Write-Host "$SoftwareName wurde erfolgreich installiert."
    }
    else {
        Write-Host "Fehler beim Herunterladen von $SoftwareName."
    }
}

Install-7Zip -Install7Zip $true
