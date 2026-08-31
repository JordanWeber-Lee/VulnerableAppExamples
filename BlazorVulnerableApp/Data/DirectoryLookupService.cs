using System.DirectoryServices;

namespace BlazorVulnerableApp.Data;

public class DirectoryLookupService
{
    private readonly string _directoryPath;

    public DirectoryLookupService(IConfiguration configuration)
    {
        _directoryPath = configuration["Directory:Path"];
    }

    public List<string> FindUsers(string userName)
    {
        var found = new List<string>();

        using var entry = new DirectoryEntry(_directoryPath);
        using var searcher = new DirectorySearcher(entry)
        {
            Filter = "(&(objectClass=user)(sAMAccountName=" + userName + "))"
        };

        searcher.PropertiesToLoad.Add("displayName");

        foreach (SearchResult result in searcher.FindAll())
        {
            if (result.Properties["displayName"].Count > 0)
            {
                found.Add(result.Properties["displayName"][0].ToString());
            }
        }

        return found;
    }
}
