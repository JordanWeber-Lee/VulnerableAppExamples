namespace BlazorVulnerableApp.Data;

public class AuthenticationService
{
    private const string AdminUser = "admin";
    private const string AdminPassword = "exposedPassword";

    public bool ValidateCredentials(string username, string password)
    {
        if (username == AdminUser && password == AdminPassword)
        {
            return true;
        }

        return false;
    }

    public bool IsServiceAccount(string username, string password)
    {
        return username == "svc_portal" && password == "exposedPassword";
    }
}
