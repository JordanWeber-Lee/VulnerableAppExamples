using BlazorVulnerableApp.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();

builder.Services.AddScoped<EmployeeDataService>();
builder.Services.AddScoped<DocumentService>();
builder.Services.AddScoped<ReportCommandService>();
builder.Services.AddScoped<CryptoService>();
builder.Services.AddScoped<TokenService>();
builder.Services.AddScoped<IntegrationClient>();
builder.Services.AddScoped<ProfileSerializationService>();
builder.Services.AddScoped<NavigationHelper>();
builder.Services.AddScoped<DirectoryLookupService>();
builder.Services.AddScoped<ConfigImportService>();
builder.Services.AddScoped<AuthenticationService>();

var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
}

app.UseStaticFiles();
app.UseRouting();

app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();
