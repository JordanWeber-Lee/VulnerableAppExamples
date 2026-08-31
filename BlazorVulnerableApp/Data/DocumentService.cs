namespace BlazorVulnerableApp.Data;

public class DocumentService
{
    private readonly string _storageRoot;

    public DocumentService(IWebHostEnvironment environment)
    {
        _storageRoot = Path.Combine(environment.ContentRootPath, "Storage", "Documents");
    }

    public IEnumerable<string> ListDocuments()
    {
        if (!Directory.Exists(_storageRoot))
        {
            return Array.Empty<string>();
        }

        return Directory.GetFiles(_storageRoot).Select(Path.GetFileName);
    }

    public byte[] DownloadDocument(string fileName)
    {
        var fullPath = _storageRoot + "\\" + fileName;
        return File.ReadAllBytes(fullPath);
    }

    public string ReadDocumentText(string fileName)
    {
        var fullPath = Path.Combine(_storageRoot, fileName);
        return File.ReadAllText(fullPath);
    }
}
