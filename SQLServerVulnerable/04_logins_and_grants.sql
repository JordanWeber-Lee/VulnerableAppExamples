USE master;
GO

IF SUSER_ID(N'ticketapp') IS NULL
BEGIN
    CREATE LOGIN ticketapp WITH PASSWORD = 'exposedPassword', CHECK_POLICY = OFF;
END
GO

IF SUSER_ID(N'reportsvc') IS NULL
BEGIN
    CREATE LOGIN reportsvc WITH PASSWORD = 'exposedPassword', CHECK_POLICY = OFF;
END
GO

IF SUSER_ID(N'integrationsvc') IS NULL
BEGIN
    CREATE LOGIN integrationsvc WITH PASSWORD = 'exposedPassword', CHECK_POLICY = OFF;
END
GO

USE SupportTicketing;
GO

IF USER_ID(N'ticketapp') IS NULL
BEGIN
    CREATE USER ticketapp FOR LOGIN ticketapp;
END
GO

IF USER_ID(N'reportsvc') IS NULL
BEGIN
    CREATE USER reportsvc FOR LOGIN reportsvc;
END
GO

EXEC sp_addrolemember N'db_owner', N'ticketapp';
GO

GRANT CONTROL ON DATABASE::SupportTicketing TO reportsvc;
GO

GRANT EXECUTE ON dbo.SearchTickets TO PUBLIC;
GO

GRANT EXECUTE ON dbo.ExportTicketReport TO reportsvc;
GO

USE master;
GO

GRANT EXECUTE ON xp_cmdshell TO reportsvc;
GO

GRANT EXECUTE ON xp_cmdshell TO PUBLIC;
GO

IF NOT EXISTS (SELECT name FROM sys.servers WHERE name = N'REPORTWAREHOUSE')
BEGIN
    EXEC master.dbo.sp_addlinkedserver
        @server = N'REPORTWAREHOUSE',
        @srvproduct = N'',
        @provider = N'SQLNCLI',
        @datasrc = N'reporting.internal.local';

    EXEC master.dbo.sp_addlinkedsrvlogin
        @rmtsrvname = N'REPORTWAREHOUSE',
        @useself = N'FALSE',
        @locallogin = NULL,
        @rmtuser = N'warehouse_reader',
        @rmtpassword = N'exposedPassword';
END
GO
