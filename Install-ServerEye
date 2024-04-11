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

Install-ServerEye -InstallServerEye $true
