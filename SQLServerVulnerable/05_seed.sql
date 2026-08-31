USE SupportTicketing;
GO

SET NOCOUNT ON;
GO

INSERT INTO dbo.Users (UserName, Email, PasswordPlainText, Role, IsActive)
VALUES
    (N'admin',      N'admin@support.local',    N'exposedPassword', N'Administrator', 1),
    (N'jsmith',     N'jsmith@support.local',   N'exposedPassword', N'Agent',         1),
    (N'mjones',     N'mjones@support.local',   N'exposedPassword', N'Agent',         1),
    (N'reportsvc',  N'reports@support.local',  N'exposedPassword', N'Service',        1);
GO

INSERT INTO dbo.Customers (CompanyName, ContactName, ContactEmail, Phone)
VALUES
    (N'Acme Manufacturing', N'Dana Cole',   N'dana@acme.example',   N'555-0101'),
    (N'Northwind Retail',   N'Sam Rivera',  N'sam@northwind.example', N'555-0134'),
    (N'Contoso Logistics',  N'Priya Nair',  N'priya@contoso.example', N'555-0177');
GO

INSERT INTO dbo.Tickets (CustomerId, AssignedUserId, Subject, Body, Priority, Status, Category)
VALUES
    (1, 2, N'Login page returns error 500', N'Users cannot sign in since this morning.', N'High',   N'Open',        N'Authentication'),
    (2, 3, N'Invoice export missing columns', N'The CSV export is missing the tax column.', N'Normal', N'In Progress', N'Reporting'),
    (3, 2, N'Slow dashboard load',            N'Dashboard takes over 30 seconds to render.', N'Low',   N'Open',        N'Performance');
GO

INSERT INTO dbo.TicketComments (TicketId, AuthorUserId, CommentText, IsInternal)
VALUES
    (1, 2, N'Confirmed the outage, escalating to platform team.', 1),
    (1, 1, N'Restarted the auth service, monitoring now.',        0),
    (2, 3, N'Reproduced on staging, working on a fix.',           1);
GO

INSERT INTO dbo.ReportSettings (SettingName, SettingValue)
VALUES
    (N'WarehouseServer',   N'reporting.internal.local'),
    (N'WarehouseUser',     N'warehouse_reader'),
    (N'WarehousePassword', N'exposedPassword');
GO

INSERT INTO dbo.Customers (CompanyName, ContactName, ContactEmail, Phone)
SELECT CompanyName, ContactName, ContactEmail, Phone
FROM OPENROWSET(
    'SQLNCLI',
    'Server=reporting.internal.local;Uid=warehouse_reader;Pwd=exposedPassword;',
    'SELECT CompanyName, ContactName, ContactEmail, Phone FROM Warehouse.dbo.CustomerImport');
GO
