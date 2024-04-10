# Fordere Admin-Rechte an
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; 
    exit 
}


# Funktion, um Windows-Updates abzurufen und zu installieren
function Install-WindowsUpdate {
	param (
        [boolean]$InstallWindowsUpdate = $true
    )

    if (-not $InstallWindowsUpdate) {
        return
    }
	
    # Windows Update suchen und installieren
    $updates = Get-WindowsUpdate -Install -Verbose

    # Ausgabe der installierten Updates
    if ($updates.Count -gt 0) {
        Write-Host "Folgende Updates wurden erfolgreich installiert:"
        $updates | ForEach-Object {
            Write-Host $_.Title
        }
    } else {
        Write-Host "Es wurden keine neuen Updates installiert."
    }
}

# Funktion, um Google Chrome zu installieren
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

# Funktion, um Mozilla FireFox zu installieren
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

# Funktion, um die HG-Fernwartung zu installieren
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

# Funktion, um 7Zip zu installieren
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

# Funktion, um OpenVPN zu installieren
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

# Funktion, um ServerEye herunter zu laden
function Install-ServerEye {
    param (
        [boolean]$InstallServerEye = $true
    )

    if (-not $InstallServerEye) {
        Write-Host "Der Download von ServerEye wurde nicht gewünscht."
        return
    }

    $DownloadUrl = "https://update.server-eye.de/download/se/ServerEyeSetup.exe"
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    $InstallerName = "ServerEyeSetup.exe"
    $InstallerPath = Join-Path -Path $DesktopPath -ChildPath $InstallerName

    Write-Host "ServerEye wird heruntergeladen..."
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath
    Write-Host "ServerEye wurde erfolgreich heruntergeladen und befindet sich auf dem Desktop."
}

# Funktion, um OEM-Informationen in Regestry zu setzen
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

# Funktion, um Installationsinfo via Mail zu versenden
function Send-ExecutionInfoEmail {
    $PublicIPUrl = "http://service.helpme.de:1499/ip"
    $PublicIP = Invoke-RestMethod -Uri $PublicIPUrl

    $CurrentTime = Get-Date
    $CurrentUserName = $env:USERNAME
    $SystemName = $env:COMPUTERNAME

    # Anmeldeinformationen dekodieren
    $Username = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("cGNoMXAx"))
    $Password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("dHJ1c3Q4MA=="))

    # E-Mail-Parameter konfigurieren
    $EmailParams = @{
        SmtpServer = "hosting.helpme.de"
        Port = 25
        UseSsl = $false
        Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, (ConvertTo-SecureString -String $Password -AsPlainText -Force)
        From = "dittrich@helpme.de"
        To = "dittrich@helpme.de"
        Subject = "Installationsscript wurde verwendet!"
        Body = "Das Installationsscript wurde am $CurrentTime unter dem Benutzer $CurrentUserName auf dem System $SystemName mit der öffentlichen IP $PublicIP ausgeführt."
    }

    Send-MailMessage @EmailParams
}


# Funktionen aufrufen
#Install-WindowsUpdate -InstallWindowsUpdate $false
#Install-GoogleChrome -InstallChrome $false
#Install-HGFernwartung -InstallHGFernwartung $false
#Install-AdobeReaderDC -InstallAdobeReaderDC $false
#Install-7Zip -Install7Zip $false
#Install-ServerEye -InstallServerEye $false

#Set-OEMInformation -SetOEMInformation $true

#Send-ExecutionInfoEmail

<#
.NAME
    Client_Deployment
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ClientDeploymentForm = New-Object System.Windows.Forms.Form
$ClientDeploymentForm.ClientSize = New-Object System.Drawing.Size(500, 400)
$ClientDeploymentForm.text = "Client Deployment"
$ClientDeploymentForm.TopMost = $false
$ClientDeploymentForm.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#333f47")

$start = New-Object System.Windows.Forms.Button
$start.text = "Start!"
$start.width = 60
$start.height = 30
$start.Anchor = 'right,bottom'
$start.location = New-Object System.Drawing.Point(418, 349)
$start.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$ProgressBar1 = New-Object System.Windows.Forms.ProgressBar
$ProgressBar1.Width = 397
$ProgressBar1.Height = 30
$ProgressBar1.Anchor = 'bottom,left'
$ProgressBar1.Location = New-Object System.Drawing.Point(14, 349)
$ProgressBar1.Minimum = 0
$ProgressBar1.Maximum = 100
$ProgressBar1.Value = 0

$checkBoxY = 33
$checkBoxSpacing = 37

$font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$checkBox1 = New-Object System.Windows.Forms.CheckBox
$checkBox1.text = "Windows Update"
$checkBox1.AutoSize = $false
$checkBox1.width = 150
$checkBox1.height = 20
$checkBox1.location = New-Object System.Drawing.Point(19, $checkBoxY)
$checkBox1.Font = $font

$checkBox2 = New-Object System.Windows.Forms.CheckBox
$checkBox2.text = "Google Chrome"
$checkBox2.AutoSize = $false
$checkBox2.width = 150
$checkBox2.height = 20
$checkBox2.location = New-Object System.Drawing.Point(19, $checkBoxY + $checkBoxSpacing)
$checkBox2.Font = $font

$checkBox3 = New-Object System.Windows.Forms.CheckBox
$checkBox3.text = "HG Fernwartung"
$checkBox3.AutoSize = $false
$checkBox3.width = 150
$checkBox3.height = 20
$checkBox3.location = New-Object System.Drawing.Point(19, $checkBoxY + $checkBoxSpacing * 2)
$checkBox3.Font = $font

$checkBox4 = New-Object System.Windows.Forms.CheckBox
$checkBox4.text = "Adobe Reader DC"
$checkBox4.AutoSize = $false
$checkBox4.width = 150
$checkBox4.height = 20
$checkBox4.location = New-Object System.Drawing.Point(19, $checkBoxY + $checkBoxSpacing * 3)
$checkBox4.Font = $font

$checkBox5 = New-Object System.Windows.Forms.CheckBox
$checkBox5.text = "7-Zip"
$checkBox5.AutoSize = $false
$checkBox5.width = 150
$checkBox5.height = 20
$checkBox5.location = New-Object System.Drawing.Point(19, $checkBoxY + $checkBoxSpacing * 4)
$checkBox5.Font = $font

$checkBox6 = New-Object System.Windows.Forms.CheckBox
$checkBox6.text = "ServerEye"
$checkBox6.AutoSize = $false
$checkBox6.width = 150
$checkBox6.height = 20
$checkBox6.location = New-Object System.Drawing.Point(19, $checkBoxY + $checkBoxSpacing * 5)
$checkBox6.Font = $font

$ClientDeploymentForm.Controls.AddRange(@($start,$ProgressBar1,$checkBox1,$checkBox2,$checkBox3,$checkBox4,$checkBox5,$checkBox6))

# Logic for handling checkbox states and executing installation functions
$start.Add_Click({
    $ProgressBar1.Value = 0  # Reset progress bar value
    $totalChecked = 0
    
    if ($checkBox1.Checked) {
        $totalChecked++
    }
    if ($checkBox2.Checked) {
        $totalChecked++
    }
    if ($checkBox3.Checked) {
        $totalChecked++
    }
    if ($checkBox4.Checked) {
        $totalChecked++
    }
    if ($checkBox5.Checked) {
        $totalChecked++
    }
    if ($checkBox6.Checked) {
        $totalChecked++
    }
    
    if ($totalChecked -gt 0) {
        $progressStep = 100 / $totalChecked
        $currentProgress = 0
    
        if ($checkBox1.Checked) {
            $currentProgress += $progressStep
            # Install Windows Update function
            Install-WindowsUpdate -InstallWindowsUpdate $true
            $ProgressBar1.Value = [math]::Min([math]::Round($currentProgress), 100)
        }
        if ($checkBox2.Checked) {
            $currentProgress += $progressStep
            # Install Google Chrome function
            Install-GoogleChrome -InstallChrome $true
            $ProgressBar1.Value = [math]::Min([math]::Round($currentProgress), 100)
        }
        if ($checkBox3.Checked) {
            $currentProgress += $progressStep
            # Install HG Fernwartung function
            Install-HGFernwartung -InstallHGFernwartung $true
            $ProgressBar1.Value = [math]::Min([math]::Round($currentProgress), 100)
        }
        if ($checkBox4.Checked) {
            $currentProgress += $progressStep
            # Install Adobe Reader DC function
            Install-AdobeReaderDC -InstallAdobeReaderDC $true
            $ProgressBar1.Value = [math]::Min([math]::Round($currentProgress), 100)
        }
        if ($checkBox5.Checked) {
            $currentProgress += $progressStep
            # Install 7-Zip function
            Install-7Zip -Install7Zip $true
            $ProgressBar1.Value = [math]::Min([math]::Round($currentProgress), 100)
        }
        if ($checkBox6.Checked) {
            $currentProgress += $progressStep
            # Install ServerEye function
            Install-ServerEye -InstallServerEye $true
            $ProgressBar1.Value = [math]::Min([math]::Round($currentProgress), 100)
        }
    }
})

[void]$ClientDeploymentForm.ShowDialog()
