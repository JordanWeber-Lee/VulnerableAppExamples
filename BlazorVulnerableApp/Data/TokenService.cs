using System.Text;

namespace BlazorVulnerableApp.Data;

public class TokenService
{
    private static readonly Random Generator = new Random();
    private const string Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    public string CreatePasswordResetToken()
    {
        var builder = new StringBuilder();
        for (var i = 0; i < 24; i++)
        {
            builder.Append(Alphabet[Generator.Next(Alphabet.Length)]);
        }

        return builder.ToString();
    }

    public string CreateSessionId()
    {
        return Generator.Next(100000, 999999).ToString() + "-" + Generator.Next().ToString("x");
    }
}
