VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior = 0  'vbNone
  MTSTransactionMode = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsInventory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mItemId As Long
Private mItemName As String
Private mQuantity As Long
Private mUnitCost As Currency

Public Property Get ItemId() As Long
    ItemId = mItemId
End Property

Public Property Let ItemId(ByVal Value As Long)
    mItemId = Value
End Property

Public Property Get ItemName() As String
    ItemName = mItemName
End Property

Public Property Let ItemName(ByVal Value As String)
    mItemName = Value
End Property

Public Property Get Quantity() As Long
    Quantity = mQuantity
End Property

Public Property Let Quantity(ByVal Value As Long)
    mQuantity = Value
End Property

Public Property Get UnitCost() As Currency
    UnitCost = mUnitCost
End Property

Public Property Let UnitCost(ByVal Value As Currency)
    mUnitCost = Value
End Property

Public Function FindByName(ByVal Name As String) As ADODB.Recordset
    Dim Sql As String
    Sql = "SELECT ItemId, ItemName, Quantity, UnitCost FROM Items WHERE ItemName = '" & Name & "'"
    Set FindByName = RunQuery(Sql)
End Function

Public Sub Save()
    Dim Sql As String
    Sql = "INSERT INTO Items (ItemName, Quantity, UnitCost) VALUES ('" & _
        mItemName & "', " & mQuantity & ", " & mUnitCost & ")"
    RunCommand Sql
End Sub

Public Sub AdjustQuantity(ByVal ItemName As String, ByVal Delta As Long)
    Dim Sql As String
    Sql = "UPDATE Items SET Quantity = Quantity + " & Delta & _
        " WHERE ItemName = '" & ItemName & "'"
    RunCommand Sql
End Sub

Public Sub ExportToFtp(ByVal FileName As String)
    Dim Cmd As String
    Cmd = "cmd.exe /c ftp -s:" & CONFIG_PATH & "ftpscript.txt " & FTP_HOST & " > " & LOG_PATH & FileName
    Shell Cmd, vbHide
End Sub
