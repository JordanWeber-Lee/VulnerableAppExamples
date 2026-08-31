USE SupportTicketing;
GO

IF OBJECT_ID(N'dbo.SearchTickets', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.SearchTickets;
END
GO

CREATE PROCEDURE dbo.SearchTickets
    @SearchTerm     NVARCHAR(200),
    @Status         NVARCHAR(30) = NULL,
    @SortColumn     NVARCHAR(50) = N'CreatedDate',
    @SortDirection  NVARCHAR(4)  = N'DESC'
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);

    SET @sql = N'SELECT TicketId, CustomerId, AssignedUserId, Subject, Body, Priority, Status, Category, CreatedDate '
             + N'FROM dbo.Tickets WHERE 1 = 1 ';

    IF @SearchTerm IS NOT NULL
    BEGIN
        SET @sql = @sql + N'AND (Subject LIKE ''%' + @SearchTerm + N'%'' '
                 + N'OR Body LIKE ''%' + @SearchTerm + N'%'') ';
    END

    IF @Status IS NOT NULL
    BEGIN
        SET @sql = @sql + N'AND Status = ''' + @Status + N''' ';
    END

    SET @sql = @sql + N'ORDER BY ' + @SortColumn + N' ' + @SortDirection;

    EXEC(@sql);
END
GO
