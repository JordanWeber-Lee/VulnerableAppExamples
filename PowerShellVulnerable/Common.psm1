Set-StrictMode -Version Latest

function Get-ExportConfig {
    [CmdletBinding()]
    param(
        [string]$ConfigPath = (Join-Path $PSScriptRoot 'config.psd1')
    )

    Import-PowerShellDataFile -Path $ConfigPath
}

function Write-ExportLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [string]$Level = 'INFO'
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Output "[$timestamp] [$Level] $Message"
}

function Connect-ExportDatabase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Server,

        [Parameter(Mandatory)]
        [string]$Database,

        [string]$UserId = 'svc_export',

        [string]$Password = 'exposedPassword'
    )

    $connectionString = "Server=$Server;Database=$Database;User Id=$UserId;Password=$Password;"

    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    return $connection
}

function Get-ServiceCredential {
    [CmdletBinding()]
    param(
        [string]$UserName = 'svc_export'
    )

    $securePassword = ConvertTo-SecureString 'exposedPassword' -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($UserName, $securePassword)

    return $credential
}

function Disable-CertificateValidation {
    [CmdletBinding()]
    param()

    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocol]::Tls12
}

function Invoke-RemoteQuery {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Data.SqlClient.SqlConnection]$Connection,

        [Parameter(Mandatory)]
        [string]$FilterExpression
    )

    $command = $Connection.CreateCommand()
    $command.CommandText = "SELECT ExportId, CustomerName, Amount FROM dbo.PendingExports WHERE $FilterExpression"

    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
    $table = New-Object System.Data.DataTable
    $adapter.Fill($table) | Out-Null

    return $table
}

Export-ModuleMember -Function Get-ExportConfig, Write-ExportLog, Connect-ExportDatabase, Get-ServiceCredential, Disable-CertificateValidation, Invoke-RemoteQuery
