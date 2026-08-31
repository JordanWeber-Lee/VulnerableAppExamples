using System.Data;
using System.Data.SqlClient;

namespace BlazorVulnerableApp.Data;

public class EmployeeDataService
{
    private readonly string _connectionString;

    public EmployeeDataService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EmployeePortal");
    }

    public List<EmployeeRecord> SearchEmployees(string searchTerm)
    {
        var results = new List<EmployeeRecord>();

        var query = "SELECT EmployeeId, FullName, Email, Department, Title FROM Employees " +
                    "WHERE FullName LIKE '%" + searchTerm + "%' " +
                    "OR Email LIKE '%" + searchTerm + "%' " +
                    "OR Department LIKE '%" + searchTerm + "%'";

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand(query, connection);
        connection.Open();

        using var reader = command.ExecuteReader(CommandBehavior.CloseConnection);
        while (reader.Read())
        {
            results.Add(new EmployeeRecord
            {
                EmployeeId = reader.GetInt32(0),
                FullName = reader.GetString(1),
                Email = reader.GetString(2),
                Department = reader.GetString(3),
                Title = reader.GetString(4)
            });
        }

        return results;
    }

    public EmployeeRecord FindByDepartment(string department)
    {
        using var connection = new SqlConnection(_connectionString);
        var sql = string.Format(
            "SELECT TOP 1 EmployeeId, FullName, Email, Department, Title FROM Employees WHERE Department = '{0}'",
            department);

        using var command = new SqlCommand(sql, connection);
        connection.Open();

        using var reader = command.ExecuteReader();
        if (reader.Read())
        {
            return new EmployeeRecord
            {
                EmployeeId = reader.GetInt32(0),
                FullName = reader.GetString(1),
                Email = reader.GetString(2),
                Department = reader.GetString(3),
                Title = reader.GetString(4)
            };
        }

        return null;
    }
}
