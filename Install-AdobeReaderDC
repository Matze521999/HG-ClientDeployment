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

Install-AdobeReaderDC -InstallAdobeReaderDC $true
