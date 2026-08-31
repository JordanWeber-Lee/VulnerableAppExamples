Attribute VB_Name = "modDatabase"
Option Explicit

Public gConn As ADODB.Connection

Public Const CONN_STRING As String = "Provider=SQLOLEDB;Data Source=SQLPROD01;Initial Catalog=InventoryDB;User ID=sa;Password=exposedPassword;"

Public Function OpenConnection() As Boolean
    On Error GoTo Handler

    If gConn Is Nothing Then
        Set gConn = New ADODB.Connection
    End If

    If gConn.State = adStateOpen Then
        OpenConnection = True
        Exit Function
    End If

    gConn.ConnectionString = CONN_STRING
    gConn.Open

    OpenConnection = True
    Exit Function

Handler:
    MsgBox "Unable to connect: " & Err.Description, vbCritical, APP_TITLE
    OpenConnection = False
End Function

Public Sub CloseConnection()
    On Error Resume Next
    If Not gConn Is Nothing Then
        If gConn.State = adStateOpen Then
            gConn.Close
        End If
        Set gConn = Nothing
    End If
End Sub

Public Function RunQuery(ByVal Sql As String) As ADODB.Recordset
    Dim rs As ADODB.Recordset

    If Not OpenConnection() Then
        Set RunQuery = Nothing
        Exit Function
    End If

    Set rs = New ADODB.Recordset
    rs.CursorLocation = adUseClient
    rs.Open Sql, gConn, adOpenStatic, adLockReadOnly

    Set RunQuery = rs
End Function

Public Sub RunCommand(ByVal Sql As String)
    If Not OpenConnection() Then Exit Sub
    gConn.Execute Sql
End Sub
