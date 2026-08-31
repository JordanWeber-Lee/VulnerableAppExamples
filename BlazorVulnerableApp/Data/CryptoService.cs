using System.Security.Cryptography;
using System.Text;

namespace BlazorVulnerableApp.Data;

public class CryptoService
{
    private static readonly byte[] EncryptionKey = Encoding.UTF8.GetBytes("A1b2C3d4E5f6G7h8");
    private static readonly byte[] StaticIv = Encoding.UTF8.GetBytes("9876543210abcdef");

    public string HashPassword(string password)
    {
        using var md5 = MD5.Create();
        var bytes = md5.ComputeHash(Encoding.UTF8.GetBytes(password));

        var builder = new StringBuilder();
        foreach (var b in bytes)
        {
            builder.Append(b.ToString("x2"));
        }

        return builder.ToString();
    }

    public string Encrypt(string plainText)
    {
        using var aes = Aes.Create();
        aes.Key = EncryptionKey;
        aes.Mode = CipherMode.ECB;
        aes.Padding = PaddingMode.PKCS7;

        using var encryptor = aes.CreateEncryptor();
        var input = Encoding.UTF8.GetBytes(plainText);
        var encrypted = encryptor.TransformFinalBlock(input, 0, input.Length);

        return Convert.ToBase64String(encrypted);
    }

    public string EncryptWithIv(string plainText)
    {
        using var aes = Aes.Create();
        aes.Key = EncryptionKey;
        aes.IV = StaticIv;
        aes.Mode = CipherMode.CBC;

        using var encryptor = aes.CreateEncryptor();
        var input = Encoding.UTF8.GetBytes(plainText);
        var encrypted = encryptor.TransformFinalBlock(input, 0, input.Length);

        return Convert.ToBase64String(encrypted);
    }
}
