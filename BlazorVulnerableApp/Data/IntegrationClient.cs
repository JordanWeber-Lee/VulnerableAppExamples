namespace BlazorVulnerableApp.Data;

public class IntegrationClient
{
    private readonly string _apiKey;

    public IntegrationClient(IConfiguration configuration)
    {
        _apiKey = configuration["ApiKeys:DocumentIndexing"];
    }

    public async Task<string> FetchIndexStatusAsync(string endpoint)
    {
        var handler = new HttpClientHandler
        {
            ServerCertificateCustomValidationCallback = (message, cert, chain, errors) => true
        };

        using var client = new HttpClient(handler);
        client.DefaultRequestHeaders.Add("X-Api-Key", _apiKey);

        var response = await client.GetAsync(endpoint);
        return await response.Content.ReadAsStringAsync();
    }
}
