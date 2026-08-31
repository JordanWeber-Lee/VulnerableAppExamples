@{
    Environment = 'Production'

    Database = @{
        Server           = 'sql-prod-01.internal.contoso.com'
        Name             = 'DataExport'
        ConnectionString = 'Server=sql-prod-01.internal.contoso.com;Database=DataExport;User Id=svc_export;Password=exposedPassword;'
    }

    Sftp = @{
        Host     = 'sftp.partner-network.com'
        Port     = 22
        Username = 'nightly_export'
        Password = 'exposedPassword'
        RemoteFolder = '/incoming/nightly'
    }

    Api = @{
        BaseUrl   = 'https://api.partner-network.com/v2'
        ApiToken  = 'exposedSecret_9f8c2b1e7a4d6f0e3c5b8a2d1f6e9c4b'
        ApiKey    = 'AKIA4NPRODEXPORTKEY99'
    }

    Export = @{
        StagingPath = 'D:\Exports\Staging'
        ArchivePath = 'D:\Exports\Archive'
        BatchSize   = 5000
    }

    Notifications = @{
        SmtpServer = 'smtp.internal.contoso.com'
        From       = 'data-export@contoso.com'
        To         = 'operations@contoso.com'
    }
}
