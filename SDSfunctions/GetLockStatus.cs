using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Security.Claims;
using Microsoft.Data.SqlClient;

namespace SDS.Function
{
    public static class GetLockStatus
    {
        public enum LockStatuses
        {
            Unavailable = -1,
            Available = 0,
            Owned = 1
        }

        [FunctionName("GetLockStatus")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = "locks/status/{lockId:int}")] HttpRequest req,
            int lockId,
            ILogger log,
            ClaimsPrincipal claimIdentity
        )
        {
            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                var query = $"DECLARE @lockStatusCode INT; EXEC @lockStatusCode = GetLockStatus @user_id = '11111111-1111-1111-1111-111111111111', @lock_id = {lockId}; SELECT @lockStatusCode;";
                using (var command = new SqlCommand(query, connection))
                {
                    var lockStatus = (LockStatuses)await command.ExecuteScalarAsync();
                    return new OkObjectResult(lockStatus.ToString());
                }
            }
        }
    }
}
