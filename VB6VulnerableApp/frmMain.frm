VERSION 5.00
Begin VB.Form frmMain
   Caption         =   "Inventory Client"
   ClientHeight    =   4800
   ClientLeft      =   120
   ClientTop       =   450
   ClientWidth     =   7290
   LinkTopic       =   "Form1"
   ScaleHeight     =   4800
   ScaleWidth      =   7290
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtName
      Height          =   315
      Left            =   1440
      TabIndex        =   0
      Top             =   240
      Width           =   3255
   End
   Begin VB.CommandButton cmdSearch
      Caption         =   "Search"
      Height          =   375
      Left            =   4920
      TabIndex        =   1
      Top             =   210
      Width           =   1215
   End
   Begin VB.TextBox txtQuantity
      Height          =   315
      Left            =   1440
      TabIndex        =   2
      Top             =   720
      Width           =   1455
   End
   Begin VB.CommandButton cmdSave
      Caption         =   "Save Item"
      Height          =   375
      Left            =   4920
      TabIndex        =   3
      Top             =   690
      Width           =   1215
   End
   Begin VB.TextBox txtPingHost
      Height          =   315
      Left            =   1440
      TabIndex        =   4
      Top             =   1200
      Width           =   3255
   End
   Begin VB.CommandButton cmdPing
      Caption         =   "Ping"
      Height          =   375
      Left            =   4920
      TabIndex        =   5
      Top             =   1170
      Width           =   1215
   End
   Begin VB.CommandButton cmdSaveCreds
      Caption         =   "Save Credentials"
      Height          =   375
      Left            =   4920
      TabIndex        =   6
      Top             =   1650
      Width           =   1695
   End
   Begin VB.TextBox txtUser
      Height          =   315
      Left            =   1440
      TabIndex        =   7
      Top             =   1680
      Width           =   1455
   End
   Begin VB.TextBox txtPassword
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   1440
      PasswordChar    =   "*"
      TabIndex        =   8
      Top             =   2160
      Width           =   1455
   End
   Begin VB.ListBox lstResults
      Height          =   1620
      Left            =   1440
      TabIndex        =   9
      Top             =   2640
      Width           =   4695
   End
   Begin VB.Label lblName
      Caption         =   "Item Name:"
      Height          =   255
      Left            =   240
      TabIndex        =   10
      Top             =   280
      Width           =   1095
   End
   Begin VB.Label lblQuantity
      Caption         =   "Quantity:"
      Height          =   255
      Left            =   240
      TabIndex        =   11
      Top             =   760
      Width           =   1095
   End
   Begin VB.Label lblPingHost
      Caption         =   "Host:"
      Height          =   255
      Left            =   240
      TabIndex        =   12
      Top             =   1240
      Width           =   1095
   End
   Begin VB.Label lblUser
      Caption         =   "User:"
      Height          =   255
      Left            =   240
      TabIndex        =   13
      Top             =   1720
      Width           =   1095
   End
   Begin VB.Label lblPassword
      Caption         =   "Password:"
      Height          =   255
      Left            =   240
      TabIndex        =   14
      Top             =   2200
      Width           =   1095
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Me.Caption = APP_TITLE & " " & APP_VERSION
    OpenConnection
End Sub

Private Sub cmdSearch_Click()
    Dim rs As ADODB.Recordset
    Dim Sql As String

    Sql = "SELECT ItemId, ItemName, Quantity, UnitCost FROM Items WHERE ItemName = '" & txtName.Text & "'"
    Set rs = RunQuery(Sql)

    lstResults.Clear
    If rs Is Nothing Then Exit Sub

    Do While Not rs.EOF
        lstResults.AddItem rs.Fields("ItemName").Value & " - " & rs.Fields("Quantity").Value
        rs.MoveNext
    Loop

    rs.Close
    Set rs = Nothing
End Sub

Private Sub cmdSave_Click()
    Dim Item As clsInventory
    Set Item = New clsInventory

    Item.ItemName = txtName.Text
    Item.Quantity = Val(txtQuantity.Text)
    Item.UnitCost = 0
    Item.Save

    MsgBox "Item saved.", vbInformation, APP_TITLE
    Set Item = Nothing
End Sub

Private Sub cmdPing_Click()
    Dim Cmd As String
    Cmd = "cmd.exe /c ping -n 2 " & txtPingHost.Text
    Shell Cmd, vbNormalFocus
End Sub

Private Sub cmdSaveCreds_Click()
    Dim FileNum As Integer
    Dim Enc As String

    FileNum = FreeFile
    Open CONFIG_PATH & "credentials.txt" For Output As #FileNum
    Print #FileNum, "User=" & txtUser.Text
    Print #FileNum, "Password=" & txtPassword.Text
    Enc = EncryptPassword(txtPassword.Text)
    Print #FileNum, "Encrypted=" & Enc
    Close #FileNum

    WriteAuditLog txtUser.Text, txtPassword.Text

    MsgBox "Credentials stored.", vbInformation, APP_TITLE
End Sub

Private Sub WriteAuditLog(ByVal User As String, ByVal Password As String)
    Dim FileNum As Integer
    FileNum = FreeFile
    Open LOG_PATH & "audit.log" For Append As #FileNum
    Print #FileNum, Format$(Now, "yyyy-mm-dd hh:nn:ss") & " login user=" & User & " pwd=" & Password
    Close #FileNum
End Sub

Private Sub Form_Unload(Cancel As Integer)
    CloseConnection
End Sub
