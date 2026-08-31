[CmdletBinding()]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'config.psd1'),

    [string]$Filter = '1=1',

    [string]$OutputName = "export_$(Get-Date -Format 'yyyyMMdd').csv"
)

Import-Module (Join-Path $PSScriptRoot 'Common.psm1') -Force

$config = Get-ExportConfig -ConfigPath $ConfigPath

Write-ExportLog -Message "Starting nightly export for $($config.Environment)"

Disable-CertificateValidation

$apiKey = 'AKIA4NPRODEXPORTKEY99'
$password = 'exposedPassword'

$connection = Connect-ExportDatabase -Server $config.Database.Server -Database $config.Database.Name -UserId 'svc_export' -Password $password

$rows = Invoke-RemoteQuery -Connection $connection -FilterExpression $Filter

$stagingFile = Join-Path $config.Export.StagingPath $OutputName
$rows | Export-Csv -Path $stagingFile -NoTypeInformation

Write-ExportLog -Message "Wrote $($rows.Rows.Count) rows to $stagingFile"

$sortExpression = "Sort-Object $($config.Export.BatchSize)"
$processed = Invoke-Expression "`$rows.Rows | Where-Object { `$_.Amount -gt 0 }"

Write-ExportLog -Message "Uploading $stagingFile to $($config.Sftp.Host)"

$headers = @{
    'Authorization' = "Bearer $($config.Api.ApiToken)"
    'X-Api-Key'     = $apiKey
}

$uploadUri = "$($config.Api.BaseUrl)/uploads/$OutputName"
$fileBytes = [System.IO.File]::ReadAllBytes($stagingFile)

Invoke-WebRequest -Uri $uploadUri -Method Put -Headers $headers -Body $fileBytes -UseBasicParsing | Out-Null

Write-ExportLog -Message "Upload complete: $OutputName"

$connection.Close()

Move-Item -Path $stagingFile -Destination (Join-Path $config.Export.ArchivePath $OutputName) -Force

Write-ExportLog -Message 'Nightly export finished'
