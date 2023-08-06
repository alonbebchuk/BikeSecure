using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Security.Claims;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;

namespace SDS.Function
{
    public static class GetUserStations
    {
        public class UserStation
        {
            public string StationName { get; set; }
            public decimal LocationLatitude { get; set; }
            public decimal LocationLongitude { get; set; }
            public decimal HourlyRate { get; set; }
            public int AvailableLocks { get; set; }
            public int UserOwnedLocks { get; set; }
        }


        [FunctionName("GetUserStations")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "stations")] HttpRequest req,
            ILogger log)
        {
            var sid = req.Headers["sid"];
            if (string.IsNullOrEmpty(sid))
            {
                return new BadRequestResult();
            }

            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                var query = $"SELECT * FROM GetUserStations('{sid}');";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        var userStations = new List<UserStation>();
                        while (await reader.ReadAsync())
                        {
                            userStations.Add(new UserStation
                            {
                                StationName = reader.GetString(0),
                                LocationLatitude = reader.GetDecimal(1),
                                LocationLongitude = reader.GetDecimal(2),
                                HourlyRate = reader.GetDecimal(3),
                                AvailableLocks = reader.GetInt32(4),
                                UserOwnedLocks = reader.GetInt32(5)
                            });
                        }
                        return new OkObjectResult(userStations);
                    }
                }
            }
        }
    }
}
