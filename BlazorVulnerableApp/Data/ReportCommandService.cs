using System.Diagnostics;

namespace BlazorVulnerableApp.Data;

public class ReportCommandService
{
    public string GenerateReport(string reportName)
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = "cmd.exe",
            Arguments = "/c reportgen.bat " + reportName,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using var process = Process.Start(startInfo);
        var output = process.StandardOutput.ReadToEnd();
        process.WaitForExit();

        return output;
    }

    public string PingHost(string host)
    {
        var process = Process.Start("cmd.exe", "/c ping -n 2 " + host);
        process.WaitForExit();
        return "Ping issued for " + host;
    }
}
