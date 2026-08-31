using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace OrdersApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AdminController : ControllerBase
{
    private readonly IConfiguration _configuration;

    public AdminController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    private string ConnectionString =>
        _configuration.GetConnectionString("OrdersDatabase") ?? string.Empty;

    [HttpDelete("orders")]
    public IActionResult PurgeAllOrders()
    {
        using var connection = new SqlConnection(ConnectionString);
        connection.Open();

        using var command = new SqlCommand("DELETE FROM Orders", connection);
        var affected = command.ExecuteNonQuery();

        return Ok(new { deleted = affected });
    }

    [HttpGet("users")]
    public IActionResult ListAllUsers()
    {
        var users = new List<object>();
        using var connection = new SqlConnection(ConnectionString);
        connection.Open();

        using var command = new SqlCommand(
            "SELECT Username, Email, PasswordHash, Role FROM Users", connection);
        using var reader = command.ExecuteReader();
        while (reader.Read())
        {
            users.Add(new
            {
                Username = reader.GetString(0),
                Email = reader.GetString(1),
                PasswordHash = reader.GetString(2),
                Role = reader.GetString(3)
            });
        }

        return Ok(users);
    }
}
