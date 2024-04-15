# Installiere das PSWindowsUpdate-Modul
Install-Module -Name PSWindowsUpdate -Force

# Importiere das PSWindowsUpdate-Modul
Import-Module PSWindowsUpdate

Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
