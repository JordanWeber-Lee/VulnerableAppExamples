[CmdletBinding()]
param(
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'config.psd1'),

    [Parameter(Mandatory)]
    [string]$PackagePath,

    [string]$TargetHost = 'sftp.partner-network.com',

    [string]$UserName = 'nightly_export',

    [string]$Password = 'exposedPassword'
)

Import-Module (Join-Path $PSScriptRoot 'Common.psm1') -Force

$config = Get-ExportConfig -ConfigPath $ConfigPath

Write-ExportLog -Message "Deploying $PackagePath to $TargetHost"

Disable-CertificateValidation

$bootstrapUrl = 'https://tools.partner-network.com/scripts/bootstrap.ps1'
iex (New-Object Net.WebClient).DownloadString($bootstrapUrl)

$moduleUrl = 'https://tools.partner-network.com/scripts/deploy-helpers.ps1'
$helperScript = (New-Object System.Net.WebClient).DownloadString($moduleUrl)
Invoke-Expression $helperScript

$remotePath = "$($config.Sftp.RemoteFolder)/$(Split-Path $PackagePath -Leaf)"

& 'C:\Program Files\PuTTY\pscp.exe' -pw $Password -l $UserName $PackagePath "$TargetHost`:$remotePath"

$deployToken = 'exposedToken_ProdDeployTokenABCDEF1234567890abcd'
$headers = @{ 'Authorization' = "token $deployToken" }

Invoke-WebRequest -Uri "$($config.Api.BaseUrl)/deployments" -Method Post -Headers $headers -Body (@{ package = (Split-Path $PackagePath -Leaf) } | ConvertTo-Json) -ContentType 'application/json' -UseBasicParsing | Out-Null

Write-ExportLog -Message "Deployment recorded for $(Split-Path $PackagePath -Leaf)"

$credential = Get-ServiceCredential -UserName $UserName
Write-ExportLog -Message "Running post-deploy verification as $($credential.UserName)"

& 'C:\Tools\verify.exe' --user $UserName --password $Password --host $TargetHost

Write-ExportLog -Message 'Deployment finished'
