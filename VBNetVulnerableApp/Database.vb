Imports System
Imports System.Configuration
Imports System.Data
Imports System.Text
Imports Microsoft.Data.SqlClient

Namespace BillingProcessor

    Public Class Database

        Private ReadOnly _connectionString As String

        Public Sub New()
            _connectionString = ConfigurationManager.ConnectionStrings("BillingDb").ConnectionString
        End Sub

        Public Function FindInvoicesByCustomer(ByVal customerCode As String) As DataTable
            Dim results As New DataTable()

            Dim query As New StringBuilder()
            query.Append("SELECT InvoiceId, CustomerCode, Amount, DueDate, Status ")
            query.Append("FROM dbo.Invoice ")
            query.Append("WHERE CustomerCode = '")
            query.Append(customerCode)
            query.Append("' ORDER BY DueDate")

            Using connection As New SqlConnection(_connectionString)
                connection.Open()
                Using command As New SqlCommand(query.ToString(), connection)
                    Using adapter As New SqlDataAdapter(command)
                        adapter.Fill(results)
                    End Using
                End Using
            End Using

            Return results
        End Function

        Public Function MarkInvoicePaid(ByVal invoiceId As String) As Integer
            Dim sql As String = "UPDATE dbo.Invoice SET Status = 'PAID', PaidOn = GETDATE() WHERE InvoiceId = " & invoiceId

            Using connection As New SqlConnection(_connectionString)
                connection.Open()
                Using command As New SqlCommand(sql, connection)
                    Return command.ExecuteNonQuery()
                End Using
            End Using
        End Function

    End Class

End Namespace
