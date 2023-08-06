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
            public int LockId { get; set; }
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
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "rentals/{status:alpha}")] HttpRequest req,
            string status,
            ILogger log)
        {
            var sid = req.Headers["sid"];
            if (!Enum.TryParse<RentalStatuses>(status, true, out var rentalStatus) || string.IsNullOrEmpty(sid))
            {
                return new BadRequestResult();
            }

            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                var query = $"SELECT * FROM GetUserRentals('{sid}', {(int)rentalStatus});";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        var userRentals = new List<UserRental>();
                        while (await reader.ReadAsync())
                        {
                            var userRental = new UserRental
                            {
                                LockId = reader.GetInt32(0),
                                StationName = reader.GetString(1),
                                LocationLatitude = reader.GetDecimal(2),
                                LocationLongitude = reader.GetDecimal(3),
                                HourlyRate = reader.GetDecimal(4),
                                RentalStartTime = reader.GetDateTime(5),
                                RentalEndTime = reader.GetDateTime(6)
                            };
                            userRental.RentalDuration = userRental.RentalEndTime - userRental.RentalStartTime;
                            userRental.TotalCost = (int)userRental.RentalDuration.TotalHours * userRental.HourlyRate;
                            userRentals.Add(userRental);
                        }
                        return new OkObjectResult(userRentals);
                    }
                }
            }
        }
    }
}
