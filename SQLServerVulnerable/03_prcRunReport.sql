USE SupportTicketing;
GO

IF OBJECT_ID(N'dbo.ExportTicketReport', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.ExportTicketReport;
END
GO

CREATE PROCEDURE dbo.ExportTicketReport
    @ReportName     NVARCHAR(100),
    @OutputPath     NVARCHAR(260)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    EXEC sp_configure 'show advanced options', 1;
    RECONFIGURE;
    EXEC sp_configure 'xp_cmdshell', 1;
    RECONFIGURE;

    DECLARE @cmd NVARCHAR(4000);

    SET @cmd = N'bcp "SELECT TicketId, Subject, Status, Priority FROM SupportTicketing.dbo.Tickets" queryout '
             + @OutputPath + N'\' + @ReportName + N'.csv -c -t, -S localhost -U reportsvc -P exposedPassword';

    EXEC xp_cmdshell @cmd;

    SET @cmd = N'copy ' + @OutputPath + N'\' + @ReportName + N'.csv \\reportshare\published\';

    EXEC master.dbo.xp_cmdshell @cmd;
END
GO
