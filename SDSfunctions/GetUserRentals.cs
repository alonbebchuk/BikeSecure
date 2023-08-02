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
    public static class GetUserRentals
    {
        public enum RentalStatuses
        {
            Past = 0,
            Current = 1
        }

        public class UserRental
        {
            public string StationName { get; set; }
            public decimal LocationLatitude { get; set; }
            public decimal LocationLongitude { get; set; }
            public decimal HourlyRate { get; set; }
            public DateTime RentalStartTime { get; set; }
            public DateTime RentalEndTime { get; set; }
            public TimeSpan RentalDuration { get; set; }
            public decimal TotalCost { get; set; }
        }

        [FunctionName("GetUserRentals")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "rentals/{status:alpha}")] HttpRequest req,
            string status,
            ILogger log,
            ClaimsPrincipal claimIdentity
        )
        {
            if (!Enum.TryParse<RentalStatuses>(status, true, out var rentalStatus))
            {
                return new BadRequestResult();
            }

            var userRentals = new List<UserRental>();
            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                var query = $"SELECT * FROM GetUserRentals('11111111-1111-1111-1111-111111111111', {(int)rentalStatus});";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            var userRental = new UserRental
                            {
                                StationName = reader.GetString(0),
                                LocationLatitude = reader.GetDecimal(1),
                                LocationLongitude = reader.GetDecimal(2),
                                HourlyRate = reader.GetDecimal(3),
                                RentalStartTime = reader.GetDateTime(4),
                                RentalEndTime = rentalStatus == RentalStatuses.Current ? DateTime.UtcNow : reader.GetDateTime(5)
                            };
                            userRental.RentalDuration = userRental.RentalEndTime - userRental.RentalStartTime;
                            userRental.TotalCost = (decimal)userRental.RentalDuration.TotalHours * userRental.HourlyRate;
                            userRentals.Add(userRental);
                        }
                    }
                }
            }
            return new OkObjectResult(userRentals);
        }
    }
}
