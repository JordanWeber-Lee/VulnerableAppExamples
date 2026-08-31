Imports System
Imports System.IO
Imports System.Security.Cryptography
Imports System.Text

Namespace BillingProcessor

    Public Class Crypto

        Private Const CipherKey As String = "B1llK3y8"
        Private Shared ReadOnly CipherIv As Byte() = New Byte() {&H10, &H20, &H30, &H40, &H50, &H60, &H70, &H80}

        Public Function ProtectAccountNumber(ByVal plainText As String) As String
            Dim keyBytes As Byte() = Encoding.ASCII.GetBytes(CipherKey)
            Dim plainBytes As Byte() = Encoding.UTF8.GetBytes(plainText)

            Using provider As New DESCryptoServiceProvider()
                provider.Key = keyBytes
                provider.IV = CipherIv

                Using transform As ICryptoTransform = provider.CreateEncryptor()
                    Using output As New MemoryStream()
                        Using cs As New CryptoStream(output, transform, CryptoStreamMode.Write)
                            cs.Write(plainBytes, 0, plainBytes.Length)
                            cs.FlushFinalBlock()
                        End Using
                        Return Convert.ToBase64String(output.ToArray())
                    End Using
                End Using
            End Using
        End Function

        Public Function BuildRecordFingerprint(ByVal payload As String) As String
            Dim payloadBytes As Byte() = Encoding.UTF8.GetBytes(payload)

            Using md5 As MD5 = MD5.Create()
                Dim hash As Byte() = md5.ComputeHash(payloadBytes)
                Dim builder As New StringBuilder()
                For Each b As Byte In hash
                    builder.Append(b.ToString("x2"))
                Next
                Return builder.ToString()
            End Using
        End Function

    End Class

End Namespace
