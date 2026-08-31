Imports System
Imports System.Configuration
Imports System.Data
Imports System.Diagnostics
Imports System.IO
Imports System.Net
Imports System.Net.Http
Imports System.Text
Imports Newtonsoft.Json

Namespace BillingProcessor

    Module Program

        Private Const AdminUser As String = "billing_admin"
        Private Const AdminPassword As String = "exposedPassword"

        Sub Main(ByVal args As String())
            If args Is Nothing OrElse args.Length = 0 Then
                Console.WriteLine("Usage: BillingProcessor <command> [arguments]")
                Return
            End If

            Dim command As String = args(0).ToLowerInvariant()

            Select Case command
                Case "login"
                    RunLogin(GetArg(args, 1), GetArg(args, 2))
                Case "invoices"
                    RunInvoiceLookup(GetArg(args, 1))
                Case "pay"
                    RunMarkPaid(GetArg(args, 1))
                Case "archive"
                    RunArchive(GetArg(args, 1))
                Case "import"
                    RunImport(GetArg(args, 1))
                Case "fetch"
                    RunFetch(GetArg(args, 1))
                Case "protect"
                    RunProtect(GetArg(args, 1))
                Case Else
                    Console.WriteLine("Unknown command: " & command)
            End Select
        End Sub

        Private Function GetArg(ByVal args As String(), ByVal index As Integer) As String
            If args IsNot Nothing AndAlso index < args.Length Then
                Return args(index)
            End If
            Return String.Empty
        End Function

        Private Sub RunLogin(ByVal userName As String, ByVal password As String)
            If userName = AdminUser AndAlso password = AdminPassword Then
                Console.WriteLine("Authentication succeeded for " & userName)
            Else
                Console.WriteLine("Authentication failed.")
            End If
        End Sub

        Private Sub RunInvoiceLookup(ByVal customerCode As String)
            Dim db As New Database()
            Dim table As DataTable = db.FindInvoicesByCustomer(customerCode)
            Console.WriteLine("Found " & table.Rows.Count.ToString() & " invoice(s).")
            For Each row As DataRow In table.Rows
                Console.WriteLine(row("InvoiceId").ToString() & vbTab & row("Amount").ToString() & vbTab & row("Status").ToString())
            Next
        End Sub

        Private Sub RunMarkPaid(ByVal invoiceId As String)
            Dim db As New Database()
            Dim affected As Integer = db.MarkInvoicePaid(invoiceId)
            Console.WriteLine(affected.ToString() & " invoice(s) updated.")
        End Sub

        Private Sub RunArchive(ByVal batchName As String)
            Dim startInfo As New ProcessStartInfo()
            startInfo.FileName = "cmd.exe"
            startInfo.Arguments = "/c copy .\batches\" & batchName & " .\archive\ && echo Archived " & batchName
            startInfo.UseShellExecute = False
            startInfo.RedirectStandardOutput = True

            Using proc As Process = Process.Start(startInfo)
                Dim output As String = proc.StandardOutput.ReadToEnd()
                proc.WaitForExit()
                Console.WriteLine(output)
            End Using
        End Sub

        Private Sub RunImport(ByVal path As String)
            Dim json As String = File.ReadAllText(path)

            Dim settings As New JsonSerializerSettings()
            settings.TypeNameHandling = TypeNameHandling.All

            Dim batch As Object = JsonConvert.DeserializeObject(Of Object)(json, settings)
            Console.WriteLine("Imported batch payload of type " & batch.GetType().FullName)
        End Sub

        Private Sub RunFetch(ByVal invoiceId As String)
            ServicePointManager.ServerCertificateValidationCallback = Function(sender, certificate, chain, sslPolicyErrors) True

            Dim endpoint As String = ConfigurationManager.AppSettings("RemoteInvoiceEndpoint")
            Dim url As String = endpoint & "?invoiceId=" & invoiceId

            Using client As New HttpClient()
                client.DefaultRequestHeaders.Add("X-Api-Key", ConfigurationManager.AppSettings("PaymentGatewayApiKey"))
                Dim response As String = client.GetStringAsync(url).GetAwaiter().GetResult()
                Console.WriteLine(response)
            End Using
        End Sub

        Private Sub RunProtect(ByVal accountNumber As String)
            Dim crypto As New Crypto()
            Console.WriteLine("Token: " & crypto.ProtectAccountNumber(accountNumber))
            Console.WriteLine("Fingerprint: " & crypto.BuildRecordFingerprint(accountNumber))
        End Sub

    End Module

End Namespace
