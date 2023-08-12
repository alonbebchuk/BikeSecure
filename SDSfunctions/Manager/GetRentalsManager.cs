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
            public string LockName { get; set; }
            public string UserId { get; set; }
            public decimal HourlyRate { get; set; }
            public DateTime StartTime { get; set; }
            public DateTime EndTime { get; set; }
            public TimeSpan Duration { get; set; }
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
                var rental = new Rental
                {
                    StationName = reader.GetString(0),
                    LockName = reader.GetString(1),
                    UserId = reader.GetString(2),
                    HourlyRate = reader.GetDecimal(3),
                    StartTime = reader.GetDateTime(4)
                };
                if (rentalStatus == RentalStatuses.Past)
                {
                    rental.EndTime = reader.GetDateTime(5);
                    rental.Duration = reader.GetTimeSpan(6);
                    rental.Cost = reader.GetDecimal(7);
                }
                rentals.Add(rental);
            }
            return new OkObjectResult(rentals);
        }
    }
}
