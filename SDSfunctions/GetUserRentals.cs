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
        public class UserRental
        {
            public int RentalId { get; set; }
            public int LockId { get; set; }
            public string StationName { get; set; }
            public DateTime RentalStartTime { get; set; }
            public DateTime RentalEndTime { get; set; }
            public int RentalDuration { get; set; }
            public decimal TotalCost { get; set; }
        }

        public static Dictionary<string, int> RentalStatuses = new Dictionary<string, int> {
            {"past", 0},
            {"current", 1},
        };

        [FunctionName("GetUserRentals")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "rentals/{rentalStatus:alpha}")] HttpRequest req,
            string rentalStatus,
            ILogger log,
            ClaimsPrincipal claimIdentity)
        {
            var isCurrent = RentalStatuses.GetValueOrDefault(rentalStatus, -1);
            if (isCurrent == -1)
            {
                return new BadRequestResult();
            }

            var userCurrentRentals = new List<UserRental>();
            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                using (var command = new SqlCommand($"SELECT * FROM GetUserRentals('11111111-1111-1111-1111-111111111111', {isCurrent});", connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            userCurrentRentals.Add(new UserRental
                            {
                                RentalId = reader.GetInt32(0),
                                LockId = reader.GetInt32(1),
                                StationName = reader.GetString(2),
                                RentalStartTime = reader.GetDateTime(3),
                                RentalEndTime = reader.GetDateTime(4),
                                RentalDuration = reader.GetInt32(5),
                                TotalCost = reader.GetDecimal(6)
                            });
                        }
                    }
                }
            }
            return new OkObjectResult(userCurrentRentals);
        }
    }
}
