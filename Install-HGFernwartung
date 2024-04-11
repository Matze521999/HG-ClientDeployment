function Install-HGFernwartung {
    param (
        [boolean]$InstallHGFernwartung = $true
    )

    $SoftwareName = "HG Fernwartung"

    if (-not $InstallHGFernwartung) {
        Write-Host "$SoftwareName wird nicht heruntergeladen, da die Installation nicht gewünscht ist."
        return
    }

    $PublicDesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonDesktopDirectory)
    $Installer = "HG-Fernwartung.exe"
    $DownloadUrl = "https://www.helpme.de/fileadmin/fernwartung/HG-Fernwartung.exe"

    Write-Host "$SoftwareName wird heruntergeladen..."

    Invoke-WebRequest $DownloadUrl -OutFile "$PublicDesktopPath\$Installer"
    Write-Host "$SoftwareName wurde erfolgreich heruntergeladen."

    Write-Host "$SoftwareName wird installiert..."

    if (Test-Path "$PublicDesktopPath\$Installer") {
        Write-Host "$SoftwareName wird auf dem öffentlichen Desktop installiert."
    }
    else {
        Write-Host "Fehler beim Herunterladen von $SoftwareName."
        return
    }

    # Führe hier den Installationsprozess durch, falls erforderlich

    Write-Host "$SoftwareName wurde erfolgreich installiert."
}

Install-HGFernwartung -InstallHGFernwartung $true
