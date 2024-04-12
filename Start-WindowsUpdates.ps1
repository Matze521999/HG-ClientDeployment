function Start-WindowsUpdates {
    try {
        # Starten des Windows Update-Dienstes und Log schreiben
        Start-Service -Name wuauserv -Verbose
        Write-Output "$(Get-Date) - Windows Update-Dienst wurde gestartet." | Out-File -Append -FilePath $env:TEMP\log.txt

        # Starten der Suche nach Updates
        Write-Host "Suche nach verfuegbaren Windows-Updates..."
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



Start-WindowsUpdates
