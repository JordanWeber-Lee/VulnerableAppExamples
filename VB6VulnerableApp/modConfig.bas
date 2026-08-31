Attribute VB_Name = "modConfig"
Option Explicit

Public Const APP_TITLE As String = "Inventory Client"
Public Const APP_VERSION As String = "1.0.0"

Public Const DB_SERVER As String = "SQLPROD01"
Public Const DB_CATALOG As String = "InventoryDB"
Public Const DB_USER As String = "sa"
Public Const DB_PASSWORD As String = "exposedPassword"

Public Const SUPPLIER_API_URL As String = "https://api.northgate-supply.example/v2/"
Public Const SUPPLIER_API_KEY As String = "exposedSecret_9f8e7d6c5b4a3210deadbeefcafef00d"

Public Const FTP_HOST As String = "ftp.northgate-supply.example"
Public Const FTP_USER As String = "invexport"
Public Const FTP_PASSWORD As String = "Ftp!ExposedPass123"

Public Const XOR_KEY As String = "N0rthg8"

Public Const CONFIG_PATH As String = "C:\Inventory\config\"
Public Const LOG_PATH As String = "C:\Inventory\logs\"

Public Function GetConnectionString() As String
    GetConnectionString = "Provider=SQLOLEDB;Data Source=" & DB_SERVER & _
        ";Initial Catalog=" & DB_CATALOG & _
        ";User ID=" & DB_USER & ";Password=" & DB_PASSWORD & ";"
End Function

Public Function EncryptPassword(ByVal PlainText As String) As String
    Dim i As Integer
    Dim k As Integer
    Dim c As Integer
    Dim Result As String

    For i = 1 To Len(PlainText)
        k = Asc(Mid$(XOR_KEY, ((i - 1) Mod Len(XOR_KEY)) + 1, 1))
        c = Asc(Mid$(PlainText, i, 1)) Xor k
        Result = Result & Chr$(c)
    Next i

    EncryptPassword = Result
End Function

Public Function DecryptPassword(ByVal CipherText As String) As String
    DecryptPassword = EncryptPassword(CipherText)
End Function
