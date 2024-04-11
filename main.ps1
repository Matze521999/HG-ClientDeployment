# Funktion zum Starten des ausgewählten Punktes
function Start-Point {
    param(
        [int]$point
    )

    $statusVariable = "status$point"
    $status = Get-Variable -Name $statusVariable -ValueOnly

    if ($status -eq "AKTIV") {
        $scriptURL = "https://raw.githubusercontent.com/Matze521999/HG-ClientDeployment/main/"
        switch ($point) {
            1 { $scriptURL += "Install-7Zip.ps1" }
            2 { $scriptURL += "Install-AdobeReaderDC.ps1" }
            3 { $scriptURL += "Install-OpenVPN.ps1" }
            4 { $scriptURL += "Install-GoogleChrome.ps1" }
            5 { $scriptURL += "Install-MozillaFirefox.ps1" }
            6 { $scriptURL += "Install-HGFernwartung.ps1" }
            7 { $scriptURL += "Install-ServerEye.ps1" }
            8 { $scriptURL += "Set-OEMInformation.ps1" }
            9 { $scriptURL += "Start-WindowsUpdates.ps1" }
        }

        # Skript herunterladen und ausführen
        Invoke-WebRequest -Uri $scriptURL -OutFile "$env:TEMP\Script.ps1"
        . "$env:TEMP\Script.ps1"
        Remove-Item "$env:TEMP\Script.ps1"
    }
}

# Startstatus und -farbe für jeden Punkt
$status1 = "AKTIV"
$status2 = "AKTIV"
$status3 = "INAKTIV"
$status4 = "AKTIV"
$status5 = "INAKTIV"
$status6 = "AKTIV"
$status7 = "INAKTIV"
$status8 = "AKTIV"
$status9 = "AKTIV"

$status1Color = "Green"
$status2Color = "Green"
$status3Color = "Red"
$status4Color = "Green"
$status5Color = "Red"
$status6Color = "Green"
$status7Color = "Red"
$status8Color = "Green"
$status9Color = "Green"

# Aktualisiere die CLI
Refresh-CLI

while ($true) {
    $key = $Host.UI.RawUI.ReadKey("IncludeKeyDown,NoEcho")

    if ($key.VirtualKeyCode -ge 49 -and $key.VirtualKeyCode -le 57) { # Überprüfen, ob die gedrückte Taste eine der Nummern 1-9 ist
        $number = $key.VirtualKeyCode - 48 # Konvertieren der Taste in die entsprechende Nummer
        Start-Point -point $number # Starte den ausgewählten Punkt
        Refresh-CLI # Aktualisiere die CLI
    } elseif ($key.VirtualKeyCode -eq 27) { # Überprüfen, ob die Escape-Taste gedrückt wurde (zum Beenden)
        break
    }
}

# Gemeinsames Skript herunterladen und ausführen
$commonScriptURL = "https://raw.githubusercontent.com/Matze521999/HG-ClientDeployment/main/Send-ExecutionInfoEmail.ps1"
Invoke-WebRequest -Uri $commonScriptURL -OutFile "$env:TEMP\CommonScript.ps1"
. "$env:TEMP\CommonScript.ps1"
Remove-Item "$env:TEMP\CommonScript.ps1"
