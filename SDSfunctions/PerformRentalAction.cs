
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System.Security.Claims;
using Microsoft.Data.SqlClient;
using System;

namespace SDS.Function
{
    public static class PerformRentalAction
    {
        public enum RentalActions
        {
            Start = 0,
            End = 1
        }

        public enum RentalActionStatuses
        {
            Unauthorized = 0,
            Completed = 1
        }

        [FunctionName("PerformRentalAction")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = "rentals/{action:alpha}/{lockId:int}")] HttpRequest req,
            string action,
            int lockId,
            ILogger log)
        {
            var sid = req.Headers["sid"];
            if (!Enum.TryParse<RentalActions>(action, true, out var rentalAction) || string.IsNullOrEmpty(sid))
            {
                return new BadRequestResult();
            }

            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                var query = $"DECLARE @rentalActionStatusCode INT; EXEC @rentalActionStatusCode = {rentalAction}Rental @user_id = '{sid}', @lock_id = {lockId}; SELECT @rentalActionStatusCode;";
                using (var command = new SqlCommand(query, connection))
                {
                    var rentalActionStatus = (RentalActionStatuses)await command.ExecuteScalarAsync();
                    return new OkObjectResult(rentalActionStatus.ToString());
                }
            }
        }
    }
}
