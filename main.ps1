# Definiere eine Hashtable, um den Status der einzelnen Optionen zu speichern
$options = @{
    "7Zip" = $true
    "AdobeReaderDC" = $true
    "OpenVPN" = $false
    "GoogleChrome" = $true
    "MozillaFirefox" = $false
    "HGFernwartung" = $true
    "ServerEye" = $false
    "OEMInformationen" = $true
    "WindowsUpdates" = $true
}

# Funktion zum Anzeigen des Menüs
function ShowMenu {
    cls
    Write-Host "`n*******************************************"
    Write-Host "*    _   _  _____  _____ ______  _____    *"
    Write-Host "*   | | | ||  __ \/  __ \|  _  \|_   _|   *"
    Write-Host "*   | |_| || |  \/| /  \/| | | |  | |     *"
    Write-Host "*   |  _  || | __ | |    | | | |  | |     *"
    Write-Host "*   | | | || |_\ \| \__/\| |/ /   | |     *"
    Write-Host "*   \_| |_/ \____/ \____/|___/    \_/     *"
    Write-Host "*                                         *"
    Write-Host "*        v5.4          (C) Matze, 2024    *"
    Write-Host "*******************************************`n"

    $i = 1
    foreach ($option in $options.GetEnumerator() | Sort-Object Name) {
        if ($option.Value) {
            Write-Host "[$i] - [X] - $($option.Key)" -ForegroundColor Green
        } else {
            Write-Host "[$i] - [ ] - $($option.Key)" -ForegroundColor Red
        }
        $i++
    }
    Write-Host "`nDruecke die entsprechende Zahl, um eine Option zu aktivieren/deaktivieren." -ForegroundColor Cyan
    Write-Host "Druecke 'y', die Installation zu starten." -ForegroundColor Cyan
}

# Funktion zum Aktivieren/Deaktivieren einer Option
function ToggleOption {
    param(
        [int]$index
    )
    $optionName = ($options.GetEnumerator() | Sort-Object Name | Select-Object -Index ($index - 1)).Key
    $options[$optionName] = -not $options[$optionName]
}

# Funktion zum Ausführen des Skripts entsprechend der ausgewählten Optionen
function ExecuteSelectedScripts {
    foreach ($option in $options.GetEnumerator() | Where-Object { $_.Value }) {
        $scriptName = "Install-" + $option.Key + ".ps1"
        $scriptURL = "https://raw.githubusercontent.com/Matze521999/HG-ClientDeployment/main/" + $scriptName
        $scriptPath = Join-Path -Path $env:TEMP -ChildPath $scriptName
        if (Test-Path $scriptPath) {
            Write-Host "Fuehre Skript $scriptName aus..." -ForegroundColor Cyan
            . $scriptPath
            Remove-Item $scriptPath
        } else {
            Write-Host "Lade Skript $scriptName herunter und fuehre es aus..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $scriptURL -OutFile $scriptPath
            . $scriptPath
            Remove-Item $scriptPath
        }
    }
}

# Hauptprogramm
while ($true) {
    ShowMenu
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
    if ($key -eq 89) { # Y-Key
        ExecuteSelectedScripts
        Write-Host "Druecke eine beliebige Taste, um fortzufahren..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        break
    } elseif ($key -ge 49 -and $key -le 57) { # Zahlen 1 bis 9
        $index = $key - 48  # 48 ist der ASCII-Wert von '0'
        ToggleOption $index
    } else {
        Write-Host "`nUngueltige Eingabe. Bitte wähle eine Option aus dem Menue oder druecke 'y' zum Bestaetigen." -ForegroundColor Yellow
    }
}
