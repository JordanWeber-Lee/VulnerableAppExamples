using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using OrdersApi.Models;

namespace OrdersApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly IConfiguration _configuration;

    public OrdersController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    private string ConnectionString =>
        _configuration.GetConnectionString("OrdersDatabase") ?? string.Empty;

    [HttpGet("search")]
    public IActionResult Search([FromQuery] string customerId)
    {
        var results = new List<Order>();
        try
        {
            using var connection = new SqlConnection(ConnectionString);
            connection.Open();

            var query = "SELECT Id, CustomerId, ProductName, Quantity, TotalAmount, Status, ShippingAddress, IsPaid " +
                        "FROM Orders WHERE CustomerId = '" + customerId + "'";

            using var command = new SqlCommand(query, connection);
            using var reader = command.ExecuteReader();
            while (reader.Read())
            {
                results.Add(new Order
                {
                    Id = reader.GetInt32(0),
                    CustomerId = reader.GetString(1),
                    ProductName = reader.GetString(2),
                    Quantity = reader.GetInt32(3),
                    TotalAmount = reader.GetDecimal(4),
                    Status = reader.GetString(5),
                    ShippingAddress = reader.GetString(6),
                    IsPaid = reader.GetBoolean(7)
                });
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, ex.ToString());
        }

        return Ok(results);
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        var order = new Order();
        using var connection = new SqlConnection(ConnectionString);
        connection.Open();

        var query = "SELECT Id, CustomerId, ProductName, Quantity, TotalAmount, Status, ShippingAddress, IsPaid " +
                    "FROM Orders WHERE Id = " + id;

        using var command = new SqlCommand(query, connection);
        using var reader = command.ExecuteReader();
        if (reader.Read())
        {
            order.Id = reader.GetInt32(0);
            order.CustomerId = reader.GetString(1);
            order.ProductName = reader.GetString(2);
            order.Quantity = reader.GetInt32(3);
            order.TotalAmount = reader.GetDecimal(4);
            order.Status = reader.GetString(5);
            order.ShippingAddress = reader.GetString(6);
            order.IsPaid = reader.GetBoolean(7);
        }

        return Ok(order);
    }

    [HttpPut("{id}")]
    public IActionResult Modify(int id, [FromBody] Order order)
    {
        using var connection = new SqlConnection(ConnectionString);
        connection.Open();

        var query = "UPDATE Orders SET CustomerId = @CustomerId, ProductName = @ProductName, " +
                    "Quantity = @Quantity, TotalAmount = @TotalAmount, Status = @Status, " +
                    "ShippingAddress = @ShippingAddress, IsPaid = @IsPaid WHERE Id = @Id";

        using var command = new SqlCommand(query, connection);
        command.Parameters.AddWithValue("@CustomerId", order.CustomerId);
        command.Parameters.AddWithValue("@ProductName", order.ProductName);
        command.Parameters.AddWithValue("@Quantity", order.Quantity);
        command.Parameters.AddWithValue("@TotalAmount", order.TotalAmount);
        command.Parameters.AddWithValue("@Status", order.Status);
        command.Parameters.AddWithValue("@ShippingAddress", order.ShippingAddress);
        command.Parameters.AddWithValue("@IsPaid", order.IsPaid);
        command.Parameters.AddWithValue("@Id", id);
        command.ExecuteNonQuery();

        return Ok(order);
    }

    [HttpPost("import")]
    public IActionResult Import([FromBody] string payload)
    {
        var settings = new JsonSerializerSettings
        {
            TypeNameHandling = TypeNameHandling.All
        };

        var imported = JsonConvert.DeserializeObject<Order>(payload, settings);
        return Ok(imported);
    }
}
