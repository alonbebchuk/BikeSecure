using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Security.Claims;
using Microsoft.Data.SqlClient;
using System.Collections.Generic;

namespace SDS.Function
{
    public static class GetLockRentalStatus
    {
        public static Dictionary<int, string> LockRentalStatuses = new Dictionary<int, string> {
            {-1, "Unavailable"},
            {0, "Available"},
            {1, "Owned"},
        };

        [FunctionName("GetLockRentalStatus")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "locks/rentalstatus/{lockId:int}")] HttpRequest req,
            int lockId,
            ILogger log,
            ClaimsPrincipal claimIdentity)
        {
            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                using (var command = new SqlCommand(
                    $"DECLARE @lockRentalStatusCode INT; EXEC @lockRentalStatusCode = GetLockRentalStatus @user_id = '11111111-1111-1111-1111-111111111111', @lock_id = {lockId}; SELECT @lockRentalStatusCode;",
                    connection))
                {
                    try
                    {
                        var lockRentalStatusCode = (int)await command.ExecuteScalarAsync();
                        var lockRentalStatus = LockRentalStatuses[lockRentalStatusCode];
                        return new OkObjectResult(lockRentalStatus);
                    }
                    catch
                    {
                        return new BadRequestResult();
                    }
                }
            }
        }
    }
}
