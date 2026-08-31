using System.Xml;

namespace BlazorVulnerableApp.Data;

public class ConfigImportService
{
    public string ImportSettings(string xmlContent)
    {
        var document = new XmlDocument
        {
            XmlResolver = new XmlUrlResolver()
        };

        var settings = new XmlReaderSettings
        {
            DtdProcessing = DtdProcessing.Parse,
            XmlResolver = new XmlUrlResolver()
        };

        using var stringReader = new StringReader(xmlContent);
        using var reader = XmlReader.Create(stringReader, settings);
        document.Load(reader);

        return document.DocumentElement?.InnerText ?? string.Empty;
    }
}
