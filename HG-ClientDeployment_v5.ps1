### GRUNDLEGENDES

# OEM
function Set-OEMInformation {
    param (
        [boolean]$SetOEMInformation = $true
    )

    if (-not $SetInfo) {
        Write-Host "Die OEM-Informationen wurden nicht gesetzt."
        return
    }

    $KeyNames = ("Manufacturer","SupportHours","SupportPhone","SupportURL","Line1","Logo")
    $KeyValues = @(
        "helpme!group - Hiltensberger & Beck GbR",
        "Montag bis Freitag, 08:00 - 17:00 Uhr",
        "+49 (0) 831 960787 0",
        "http://www.helpme.de",
        "",
        "" # Hier wird der Pfad zum Logo platziert
    )

    # Logo herunterladen
    $LogoUrl = "https://share.matthias-dittrich.de/index.php/s/jjprHzbgWoSW5rb/download/helpme.bmp"
    $LogoPath = "C:\Windows\System32\oemlogo.bmp"

    # Bild herunterladen und Log schreiben
    try {
        Invoke-WebRequest -Uri $LogoUrl -OutFile $LogoPath
        Write-Output "$(Get-Date) - Logo wurde erfolgreich heruntergeladen und gespeichert: $LogoPath" | Out-File -Append -FilePath $env:TEMP\log.txt
    } catch {
        Write-Output "$(Get-Date) - Fehler beim Herunterladen und Speichern des Logos: $_" | Out-File -Append -FilePath $env:TEMP\log.txt
    }

    $KeyValues[5] = $LogoPath

    for ($i = 0; $i -lt $KeyNames.Count; $i++) {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name $KeyNames[$i] -Value $KeyValues[$i]
    }

    Write-Host "Die OEM-Informationen wurden erfolgreich gesetzt."
    Write-Output "$(Get-Date) - Die OEM-Informationen wurden erfolgreich gesetzt." | Out-File -Append -FilePath $env:TEMP\log.txt
}


# Windows Updates
function Start-WindowsUpdates {
    try {
        # Starten des Windows Update-Dienstes und Log schreiben
        Start-Service -Name wuauserv -Verbose
        Write-Output "$(Get-Date) - Windows Update-Dienst wurde gestartet." | Out-File -Append -FilePath $env:TEMP\log.txt

        # Starten der Suche nach Updates
        Write-Host "Suche nach verfügbaren Windows-Updates..."
        $SearchResult = (New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher().Search($null).Updates

        # Überprüfen, ob Updates gefunden wurden
        if ($SearchResult.Count -eq 0) {
            Write-Host "Es wurden keine neuen Windows-Updates gefunden."
            Write-Output "$(Get-Date) - Es wurden keine neuen Windows-Updates gefunden." | Out-File -Append -FilePath $env:TEMP\log.txt
            return
        }

        # Installieren der gefundenen Updates und Log schreiben
        Write-Host "Es wurden $($SearchResult.Count) neue Windows-Updates gefunden. Beginne mit der Installation..."
        Write-Output "$(Get-Date) - Es wurden $($SearchResult.Count) neue Windows-Updates gefunden. Beginne mit der Installation." | Out-File -Append -FilePath $env:TEMP\log.txt

        $Installer = (New-Object -ComObject Microsoft.Update.Installer)
        $Installer.Updates = $SearchResult
        $InstallationResult = $Installer.Install()

        # Überprüfen, ob die Installation erfolgreich war
        if ($InstallationResult.ResultCode -eq 2) {
            Write-Host "Windows-Updates wurden erfolgreich installiert."
            Write-Output "$(Get-Date) - Windows-Updates wurden erfolgreich installiert." | Out-File -Append -FilePath $env:TEMP\log.txt
        } else {
            Write-Host "Fehler beim Installieren der Windows-Updates: $($InstallationResult.ResultCode)"
            Write-Output "$(Get-Date) - Fehler beim Installieren der Windows-Updates: $($InstallationResult.ResultCode)" | Out-File -Append -FilePath $env:TEMP\log.txt

            # Ausgabe der Namen der fehlgeschlagenen Updates und Log schreiben
            $FailedUpdates = $SearchResult | Where-Object { $_.IsInstalled -eq $false }
            if ($FailedUpdates.Count -gt 0) {
                Write-Host "Folgende Updates konnten nicht installiert werden:"
                Write-Output "$(Get-Date) - Folgende Updates konnten nicht installiert werden:" | Out-File -Append -FilePath $env:TEMP\log.txt
                $FailedUpdates | ForEach-Object {
                    Write-Host "- $($_.Title)"
                    Write-Output "$(Get-Date) - $($_.Title)" | Out-File -Append -FilePath $env:TEMP\log.txt
                }
            }
        }
    } catch {
        Write-Host "Fehler beim Starten der Windows-Updates aufgetreten: $_"
        Write-Output "$(Get-Date) - Fehler beim Starten der Windows-Updates aufgetreten: $_" | Out-File -Append -FilePath $env:TEMP\log.txt
    }
}



### SOFTWARE

# Google Chrome
function Install-GoogleChrome {
    param (
        [boolean]$InstallChrome = $true
    )

    if (-not $InstallChrome) {
        Write-Host "Die Installation von Google Chrome wurde nicht gewünscht."
        Write-Output "$(Get-Date) - Die Installation von Google Chrome wurde nicht gewünscht." | Out-File -Append -FilePath $env:TEMP\log.txt
        return
    }

    $Path = $env:TEMP;
    $Installer = "chrome_installer.exe";
    Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer;
    Write-Host "Starte die Installation von Google Chrome..."
    Write-Output "$(Get-Date) - Starte die Installation von Google Chrome..." | Out-File -Append -FilePath $env:TEMP\log.txt
    Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait;
    Write-Host "Google Chrome wurde erfolgreich installiert."
    Write-Output "$(Get-Date) - Google Chrome wurde erfolgreich installiert." | Out-File -Append -FilePath $env:TEMP\log.txt
    Remove-Item $Path\$Installer
}


# Mozilla FireFox
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


# HG Fernwartung
function Install-HGFernwartung {
    $DownloadUrl = "https://www.helpme.de/fileadmin/fernwartung/HG-Fernwartung.exe"
    $PublicDesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonDesktopDirectory)
    $InstallerPath = Join-Path $PublicDesktopPath "HG-Fernwartung.exe"
    Write-Host "Starte die Installation von HG Fernwartung..."
    Write-Output "$(Get-Date) - Starte die Installation von HG Fernwartung..." | Out-File -Append -FilePath $env:TEMP\log.txt
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath
    Write-Host "HG Fernwartung wurde erfolgreich installiert."
    Write-Output "$(Get-Date) - HG Fernwartung wurde erfolgreich installiert." | Out-File -Append -FilePath $env:TEMP\log.txt
}


# ServerEye
function Install-ServerEye {
    param (
        [boolean]$InstallServerEye = $true
    )

    if (-not $InstallServerEye) {
        Write-Host "Die Installation von ServerEye wurde nicht gewünscht."
        Write-Output "$(Get-Date) - Die Installation von ServerEye wurde nicht gewünscht." | Out-File -Append -FilePath $env:TEMP\log.txt
        return
    }

    $DownloadUrl = "https://update.server-eye.de/download/se/ServerEyeSetup.exe"
    $PublicDesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonDesktopDirectory)
    $InstallerPath = Join-Path $PublicDesktopPath "ServerEyeSetup.exe"
    Write-Host "Starte den Download von ServerEye..."
    Write-Output "$(Get-Date) - Starte den Download von ServerEye..." | Out-File -Append -FilePath $env:TEMP\log.txt
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath
    Write-Host "ServerEye wurde erfolgreich herunter geladen."
    Write-Output "$(Get-Date) - ServerEye wurde erfolgreich herunter geladen." | Out-File -Append -FilePath $env:TEMP\log.txt
}


# OpenVPN
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


# Adobe Reader DC
function Install-AdobeReaderDC {
    param (
        [boolean]$InstallAdobeReader = $true
    )

    if (-not $InstallAdobeReader) {
        Write-Host "Die Installation von Adobe Reader DC wurde nicht gewünscht."
        return
    }

    # Installiere Adobe Reader DC mit winget und Log schreiben
    Write-Host "Starte die Installation von Adobe Reader DC..."
    winget install -e --id Adobe.Acrobat.Reader.64-bit --silent --accept-package-agreements --accept-source-agreements
    Write-Host "Adobe Reader DC wurde erfolgreich installiert."

    Write-Output "$(Get-Date) - Adobe Reader DC wurde erfolgreich installiert." | Out-File -Append -FilePath $env:TEMP\log.txt
}



### OPTISCHES

#




### OVERHEAD

#Audiostream

function PlayAudioFromUrl {
    param (
        [string]$Url
    )

    # Speicherort für das temporäre Audio-Datei
    $tempFile = "temp_audio.wav"

    try {
        # Audio herunterladen
        Invoke-WebRequest -Uri $Url -OutFile $tempFile -ErrorAction Stop

        # Abspielen des Audios mit dem System.Media.SoundPlayer
        $player = New-Object System.Media.SoundPlayer
        $player.SoundLocation = $tempFile
        $player.Play()

        Write-Host "Audio wird abgespielt..."

        # Warten, bis die Wiedergabe beendet ist
        Start-Sleep -Seconds 60  # 60 Sekunden warten, Sie können diese Zeit anpassen

        Write-Host "Wiedergabe beendet."

    } catch {
        Write-Host "Fehler beim Herunterladen oder Abspielen des Audios: $_"
    } finally {
        # Löschen der temporären Audio-Datei
        if (Test-Path $tempFile) {
            Remove-Item $tempFile
        }
    }
}

# Beispielaufruf der Funktion mit dem bereitgestellten URL





Set-OEMInformation $true
Install-GoogleChrome $true
Install-MozillaFirefox $true
Install-HGFernwartung $true
Install-ServerEye $true
Install-AdobeReaderDC $true
Install-OpenVPN $true
Start-WindowsUpdates
