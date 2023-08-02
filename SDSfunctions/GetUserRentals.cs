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
            public int rental_id { get; set; }
            public int lock_id { get; set; }
            public DateTime rental_start_time { get; set; }
            public DateTime rental_end_time { get; set; }
            public int rental_duration { get; set; }
            public decimal total_cost { get; set; }
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
                            userCurrentRentals.Add(new UserRental {
                                rental_id = reader.GetInt32(0),
                                lock_id = reader.GetInt32(1),
                                rental_start_time = reader.GetDateTime(2),
                                rental_end_time = reader.GetDateTime(3),
                                rental_duration = reader.GetInt32(4),
                                total_cost = reader.GetDecimal(5)
                            });
                        }
                    }
                }
            }
            return new OkObjectResult(userCurrentRentals);
        }
    }
}
