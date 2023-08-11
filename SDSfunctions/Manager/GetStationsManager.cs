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
    public static class GetStationsManager
    {
        public class Station
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public decimal HourlyRate { get; set; }
            public decimal Latitude { get; set; }
            public decimal Longitude { get; set; }
            public int LockCount { get; set; }
            public int FreeLockCount { get; set; }
            public int OwnedLockCount { get; set; }
        }


        [FunctionName("GetStationsManager")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "manage/stations")] HttpRequest req
        )
        {
            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                var query = $"SELECT * FROM GetStations(NULL);";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        var stations = new List<Station>();
                        while (await reader.ReadAsync())
                        {
                            var station = new Station
                            {
                                Id = reader.GetInt32(0),
                                Name = reader.GetString(1),
                                HourlyRate = reader.GetDecimal(2),
                                Latitude = reader.GetDecimal(3),
                                Longitude = reader.GetDecimal(4),
                                LockCount = reader.GetInt32(5),
                                FreeLockCount = reader.GetInt32(6)
                            };
                            station.OwnedLockCount = station.LockCount - station.FreeLockCount;
                            stations.Add(station);
                        }
                        return new OkObjectResult(stations);
                    }
                }
            }
        }
    }
}
