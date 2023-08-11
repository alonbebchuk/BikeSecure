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
    public static class GetRentals
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
            public TimeSpan Duration { get; set; }
            public decimal Cost { get; set; }
        }

        [FunctionName("GetRentals")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "rentals/{status:alpha}")] HttpRequest req,
            string status,
            ILogger log)
        {
            if (!Enum.TryParse<RentalStatuses>(status, true, out var rentalStatus))
            {
                return new BadRequestResult();
            }

            var sid = "user_413046ae5f07424db6ba9da0c4340a24";
            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                var query = $"SELECT * FROM Get{rentalStatus}Rentals('{sid}');";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        var rentals = new List<Rental>();
                        while (await reader.ReadAsync())
                        {
                            var rental = new Rental
                            {
                                StationName = reader.GetString(0),
                                Latitude = reader.GetDecimal(1),
                                Longitude = reader.GetDecimal(2),
                                LockId = reader.GetGuid(3),
                                LockName = reader.GetString(4),
                                HourlyRate = reader.GetDecimal(5),
                                StartTime = reader.GetDateTime(6)
                            };
                            if (rentalStatus == RentalStatuses.Past) {
                                rental.EndTime = reader.GetDateTime(7);
                                rental.Duration = reader.GetTimeSpan(8);
                                rental.Cost = reader.GetDecimal(9);
                            }

                            rentals.Add(rental);
                        }
                        return new OkObjectResult(rentals);
                    }
                }
            }
        }
    }
}
