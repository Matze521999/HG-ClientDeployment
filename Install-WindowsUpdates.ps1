# Installiere das PSWindowsUpdate-Modul
Install-Module -Name PSWindowsUpdate -Force

# Importiere das PSWindowsUpdate-Modul
Import-Module PSWindowsUpdate

# Installiere Windows-Updates ohne Benutzereingriff
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
