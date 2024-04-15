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
        Body = "Das Installationsscript wurde am $CurrentTime unter dem Benutzer $CurrentUserName auf dem System $SystemName mit der oeffentlichen IP $PublicIP ausgefuehrt."
    }

    Send-MailMessage @EmailParams
}

Send-ExecutionInfoEmail
