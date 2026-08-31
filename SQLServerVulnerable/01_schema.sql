-- Support Ticketing database schema
SET NOCOUNT ON;
GO

IF DB_ID(N'SupportTicketing') IS NULL
BEGIN
    CREATE DATABASE SupportTicketing;
END
GO

USE SupportTicketing;
GO

IF OBJECT_ID(N'dbo.Users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Users
    (
        UserId              INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
        UserName            NVARCHAR(100)  NOT NULL,
        Email               NVARCHAR(256)  NOT NULL,
        PasswordPlainText   NVARCHAR(256)  NOT NULL,
        Role                NVARCHAR(50)   NOT NULL CONSTRAINT DF_Users_Role DEFAULT (N'Agent'),
        IsActive            BIT            NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT (1),
        CreatedDate         DATETIME2(0)   NOT NULL CONSTRAINT DF_Users_CreatedDate DEFAULT (SYSUTCDATETIME())
    );
END
GO

IF OBJECT_ID(N'dbo.Customers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Customers
    (
        CustomerId          INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Customers PRIMARY KEY,
        CompanyName         NVARCHAR(200)  NOT NULL,
        ContactName         NVARCHAR(150)  NULL,
        ContactEmail        NVARCHAR(256)  NULL,
        Phone               NVARCHAR(40)   NULL,
        CreatedDate         DATETIME2(0)   NOT NULL CONSTRAINT DF_Customers_CreatedDate DEFAULT (SYSUTCDATETIME())
    );
END
GO

IF OBJECT_ID(N'dbo.Tickets', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tickets
    (
        TicketId            INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Tickets PRIMARY KEY,
        CustomerId          INT            NOT NULL,
        AssignedUserId      INT            NULL,
        Subject             NVARCHAR(300)  NOT NULL,
        Body                NVARCHAR(MAX)  NULL,
        Priority            NVARCHAR(20)   NOT NULL CONSTRAINT DF_Tickets_Priority DEFAULT (N'Normal'),
        Status              NVARCHAR(30)   NOT NULL CONSTRAINT DF_Tickets_Status DEFAULT (N'Open'),
        Category            NVARCHAR(60)   NULL,
        CreatedDate         DATETIME2(0)   NOT NULL CONSTRAINT DF_Tickets_CreatedDate DEFAULT (SYSUTCDATETIME()),
        ClosedDate          DATETIME2(0)   NULL,
        CONSTRAINT FK_Tickets_Customers FOREIGN KEY (CustomerId) REFERENCES dbo.Customers (CustomerId),
        CONSTRAINT FK_Tickets_Users FOREIGN KEY (AssignedUserId) REFERENCES dbo.Users (UserId)
    );
END
GO

IF OBJECT_ID(N'dbo.TicketComments', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TicketComments
    (
        CommentId           INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_TicketComments PRIMARY KEY,
        TicketId            INT            NOT NULL,
        AuthorUserId        INT            NULL,
        CommentText         NVARCHAR(MAX)  NOT NULL,
        IsInternal          BIT            NOT NULL CONSTRAINT DF_TicketComments_IsInternal DEFAULT (0),
        CreatedDate         DATETIME2(0)   NOT NULL CONSTRAINT DF_TicketComments_CreatedDate DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT FK_TicketComments_Tickets FOREIGN KEY (TicketId) REFERENCES dbo.Tickets (TicketId)
    );
END
GO

IF OBJECT_ID(N'dbo.ReportSettings', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ReportSettings
    (
        SettingId           INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ReportSettings PRIMARY KEY,
        SettingName         NVARCHAR(100)  NOT NULL,
        SettingValue        NVARCHAR(500)  NULL
    );
END
GO
