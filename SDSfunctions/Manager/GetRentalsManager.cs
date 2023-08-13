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
    public static class GetRentalsManager
    {
        public enum RentalStatuses
        {
            Past = 0,
            Current = 1
        }

        public class Rental
        {
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

        [FunctionName("GetRentalsManager")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "manage/rentals/{status:alpha}/{stationId:int}")] HttpRequest req,
            string status,
            int stationId
        )
        {
            if (!Enum.TryParse<RentalStatuses>(status, true, out var rentalStatus))
            {
                return new BadRequestResult();
            }

            using var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString"));
            connection.Open();
            var query = $"SELECT * FROM Get{rentalStatus}RentalsManager({stationId});";
            using var command = new SqlCommand(query, connection);
            using var reader = await command.ExecuteReaderAsync();
            var rentals = new List<Rental>();
            while (await reader.ReadAsync())
            {
                rentals.Add(new Rental
                {
                    StationName = reader.GetString(0),
                    Latitude = reader.GetDecimal(1),
                    Longitude = reader.GetDecimal(2),
                    LockId = reader.GetGuid(3),
                    LockName = reader.GetString(4),
                    HourlyRate = reader.GetDecimal(5),
                    StartTime = reader.GetDateTime(6),
                    EndTime = reader.GetDateTime(7),
                    DurationDays = reader.GetInt32(8),
                    DurationHours = reader.GetInt32(9),
                    Cost = reader.GetDecimal(10)
                });
            }
            return new OkObjectResult(rentals);
        }
    }
}
