using Newtonsoft.Json;

namespace BlazorVulnerableApp.Data;

public class EmployeeProfile
{
    public string DisplayName { get; set; }
    public string Department { get; set; }
    public Dictionary<string, string> Preferences { get; set; }
}

public class ProfileSerializationService
{
    public EmployeeProfile LoadProfile(string json)
    {
        var settings = new JsonSerializerSettings
        {
            TypeNameHandling = TypeNameHandling.All
        };

        return JsonConvert.DeserializeObject<EmployeeProfile>(json, settings);
    }

    public object LoadState(string json)
    {
        return JsonConvert.DeserializeObject(json, new JsonSerializerSettings
        {
            TypeNameHandling = TypeNameHandling.Auto
        });
    }
}
