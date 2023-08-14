using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using System;
using Microsoft.Data.SqlClient;

namespace SDS.Function
{
    public static class GetLock
    {
        public enum LockStatuses
        {
            Available = 0,
            Owned = 1,
            Unavailable = -1
        }

        public class Lock
        {
            public LockStatuses LockStatus { get; set; }
            public string StationName { get; set; }
            public decimal Latitude { get; set; }
            public decimal Longitude { get; set; }
            public Guid LockId { get; set; }
            public string LockName { get; set; }
            public decimal HourlyRate { get; set; }
            public DateTime StartTime { get; set; }
            public DateTime EndTime { get; set; }
            public int DurationDays { get; set; }
            public int DurationHours { get; set; }
            public decimal Cost { get; set; }
        }

        [FunctionName("GetLock")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "locks/data/{lockId:guid}")] HttpRequest req,
            Guid lockId
        )
        {
            if (!Authentication.Authenticate(req))
            {
                return new BadRequestResult();
            }

            var sid = req.Headers["sid"];
            using var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString"));
            connection.Open();
            var query = $"SELECT * FROM GetLock('{sid}', '{lockId}');";
            using var command = new SqlCommand(query, connection);
            using var reader = await command.ExecuteReaderAsync();
            await reader.ReadAsync();
            var lockData = new Lock
            {
                LockStatus = (LockStatuses)reader.GetInt32(0),
                StationName = reader.GetString(1),
                Latitude = reader.GetDecimal(2),
                Longitude = reader.GetDecimal(3),
                LockId = reader.GetGuid(4),
                LockName = reader.GetString(5),
                HourlyRate = reader.GetDecimal(6)
            };
            if (lockData.LockStatus == LockStatuses.Owned)
            {
                lockData.StartTime = reader.GetDateTime(7);
                lockData.EndTime = reader.GetDateTime(8);
                lockData.DurationDays = reader.GetInt32(9);
                lockData.DurationHours = reader.GetInt32(10);
                lockData.Cost = reader.GetDecimal(11);
            }
            return new OkObjectResult(lockData);
        }
    }
}
