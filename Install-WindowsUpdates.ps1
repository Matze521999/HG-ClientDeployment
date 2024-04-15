# Installiere das PSWindowsUpdate-Modul
Install-Module -Name PSWindowsUpdate -Force

# Importiere das PSWindowsUpdate-Modul
Import-Module PSWindowsUpdate

# Definiere eine Funktion zum Installieren von Updates und zur Fehlerbehandlung
function Install-UpdatesWithRetry {
    $retryCount = 3  # Anzahl der Versuche, das Update zu installieren

    for ($i = 1; $i -le $retryCount; $i++) {
        Write-Host "Versuch $i von $retryCount, Windows-Updates zu installieren..."

        # Installiere Windows-Updates
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

        # Überprüfe auf Fehler bei der Installation
        $lastInstallResult = Get-WindowsUpdateLog | Where-Object { $_.Message -like "*failed*" }

        # Wenn kein Fehler aufgetreten ist, breche die Schleife ab
        if (-not $lastInstallResult) {
            Write-Host "Updates wurden erfolgreich installiert."
            break
        }

        # Wenn ein Fehler aufgetreten ist und es nicht der letzte Versuch ist, warte eine Weile und versuche erneut
        if ($i -lt $retryCount) {
            Write-Host "Fehler bei der Installation festgestellt. Warte und versuche erneut..."
            Start-Sleep -Seconds 30
        } else {
            Write-Host "Fehler bei der Installation festgestellt. Maximale Anzahl von Versuchen erreicht."
        }
    }
}

# Rufe die Funktion zum Installieren von Updates mit Fehlerbehandlung auf
Install-UpdatesWithRetry
