using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;

namespace SDS.Function
{
    public static class GetLocksManager
    {
        public class Lock
        {
            public Guid LockId { get; set; }
            public string LockName { get; set; }
            public string UserId { get; set; }
            public bool Deleted { get; set; }
        }

        [FunctionName("GetLocksManager")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "manage/locks/{stationId:int}")] HttpRequest req,
            int stationId
        )
        {
            using var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString"));
            connection.Open();
            var query = $"SELECT * FROM GetLocksManager({stationId});";
            using var command = new SqlCommand(query, connection);
            using var reader = await command.ExecuteReaderAsync();
            var locks = new List<Lock>();
            while (await reader.ReadAsync())
            {
                locks.Add(new Lock
                {
                    LockId = reader.GetGuid(0),
                    LockName = reader.GetString(1),
                    UserId = reader.IsDBNull(2) ? null : reader.GetString(2),
                    Deleted = reader.GetBoolean(3)
                });
            }
            return new OkObjectResult(locks);
        }
    }
}
