### GRUNDLEGENDES

# OEM
function Set-OEMInformation {
    param (
        [boolean]$SetInfo = $true
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

    # Bild herunterladen
    Invoke-WebRequest -Uri $LogoUrl -OutFile $LogoPath

    $KeyValues[5] = $LogoPath

    for ($i = 0; $i -lt $KeyNames.Count; $i++) {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name $KeyNames[$i] -Value $KeyValues[$i]
    }

    Write-Host "Die OEM-Informationen wurden erfolgreich gesetzt."
}

# Windows Updates
function Start-WindowsUpdates {
    try {
        # Starten des Windows Update-Dienstes
        Start-Service -Name wuauserv -Verbose

        # Starten der Suche nach Updates
        Write-Host "Suche nach verfügbaren Windows-Updates..."
        $SearchResult = (New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher().Search($null).Updates

        # Überprüfen, ob Updates gefunden wurden
        if ($SearchResult.Count -eq 0) {
            Write-Host "Es wurden keine neuen Windows-Updates gefunden."
            return
        }

        # Installieren der gefundenen Updates
        Write-Host "Es wurden $($SearchResult.Count) neue Windows-Updates gefunden. Beginne mit der Installation..."

        $Installer = (New-Object -ComObject Microsoft.Update.Installer)
        $Installer.Updates = $SearchResult
        $InstallationResult = $Installer.Install()

        # Überprüfen, ob die Installation erfolgreich war
        if ($InstallationResult.ResultCode -eq 2) {
            Write-Host "Windows-Updates wurden erfolgreich installiert."
        } else {
            Write-Host "Fehler beim Installieren der Windows-Updates: $($InstallationResult.ResultCode)"

            # Ausgabe der Namen der fehlgeschlagenen Updates
            $FailedUpdates = $SearchResult | Where-Object { $_.IsInstalled -eq $false }
            if ($FailedUpdates.Count -gt 0) {
                Write-Host "Folgende Updates konnten nicht installiert werden:"
                $FailedUpdates | ForEach-Object {
                    Write-Host "- $($_.Title)"
                }
            }
        }
    } catch {
        Write-Host "Fehler beim Starten der Windows-Updates aufgetreten: $_"
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
        return
    }

    $Path = $env:TEMP;
    $Installer = "chrome_installer.exe";
    Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer;
    Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait;
    Remove-Item $Path\$Installer
}

# Mozilla FireFox
function Install-MozillaFirefox {
    param (
        [boolean]$InstallFirefox = $true
    )

    if (-not $InstallFirefox) {
        Write-Host "Die Installation von Mozilla Firefox wurde nicht gewünscht."
        return
    }

    $Path = $env:TEMP;
    $Installer = "firefox_installer.exe";
    Invoke-WebRequest "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=de" -OutFile $Path\$Installer;
    Start-Process -FilePath $Path\$Installer -Args "/S" -Verb RunAs -Wait;
    Remove-Item $Path\$Installer
}

# HG Fernwartung
function Install-HGFernwartung {
    $DownloadUrl = "https://www.helpme.de/fileadmin/fernwartung/HG-Fernwartung.exe"
    $PublicDesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonDesktopDirectory)
    $InstallerPath = Join-Path $PublicDesktopPath "HG-Fernwartung.exe"
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath
}

# ServerEye
function Install-ServerEye {
    param (
        [boolean]$InstallServerEye = $true
    )

    if (-not $InstallServerEye) {
        Write-Host "Die Installation von ServerEye wurde nicht gewünscht."
        return
    }

    $DownloadUrl = "https://update.server-eye.de/download/se/ServerEyeSetup.exe"
    $PublicDesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonDesktopDirectory)
    $InstallerPath = Join-Path $PublicDesktopPath "ServerEyeSetup.exe"
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath
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

    # Installiere Adobe Reader DC mit winget
    winget install -e --id Adobe.Acrobat.Reader.64-bit -h --accept-package-agreements
}

# OpenVPN
function Install-OpenVPN {
    param (
        [boolean]$InstallOpenVPN = $true
    )

    if (-not $InstallOpenVPN) {
        Write-Host "Die Installation von OpenVPN wurde nicht gewünscht."
        return
    }

    # URL für den direkten Download von OpenVPN
    $DownloadUrl = "https://swupdate.openvpn.org/community/releases/OpenVPN-2.6.9-I001-amd64.msi"

    # Pfad für den Speicherort der heruntergeladenen Datei
    $InstallerPath = "$env:TEMP\OpenVPN-2.6.9-I001-amd64.msi"

    # Herunterladen von OpenVPN
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath

    # Starten der Installation
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$InstallerPath`" /quiet" -Wait

    # Aufräumen
    Remove-Item $InstallerPath
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





# Aufruf der Funktion

$Job1 = Start-Job -ScriptBlock { PlayAudioFromUrl -Url "https://share.matthias-dittrich.de/index.php/s/p3qxKcB7LzRgNQK/download/audio.wav" }
$Job2 = Start-Job -ScriptBlock { Start-WindowsUpdates }



Set-OEMInformation -SetInfo $true
Install-GoogleChrome $true
Install-MozillaFirefox $true
Install-HGFernwartung $true
Install-ServerEye $true
Install-AdobeReaderDC $true
Install-OpenVPN $true

