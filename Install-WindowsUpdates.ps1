# Installiere das PSWindowsUpdate-Modul
Install-Module -Name PSWindowsUpdate -Force

# Importiere das PSWindowsUpdate-Modul
Import-Module PSWindowsUpdate

# Definiere eine Funktion zum Installieren von Updates und zur Fehlerbehandlung
function Install-UpdatesWithRetry {
    # Installiere Windows-Updates
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

    # Überprüfe auf Fehler bei der Installation
    $lastInstallResult = Get-WindowsUpdateLog | Where-Object { $_.Message -like "*failed*" }

    # Wenn ein Fehler aufgetreten ist, versuche erneut, das Update zu installieren
    if ($lastInstallResult) {
        Write-Host "Fehler bei der Installation festgestellt. Versuche, das Update erneut zu installieren..."
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
    }
}

# Rufe die Funktion zum Installieren von Updates mit Fehlerbehandlung auf
Install-UpdatesWithRetry
