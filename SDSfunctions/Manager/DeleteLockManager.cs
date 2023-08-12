using System;
using System.IO;
using Newtonsoft.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Data.SqlClient;

namespace SDS.Function
{
    public static class DeleteLockManager
    {
        public class Lock
        {
            public Guid LockId { get; set; }
        }

        [FunctionName("DeleteLockManager")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "manage/locks/delete")] HttpRequest req
        )
        {
            var requestBody = String.Empty;
            using (StreamReader streamReader = new StreamReader(req.Body))
            {
                requestBody = await streamReader.ReadToEndAsync();
            }
            var lockId = JsonConvert.DeserializeObject<Lock>(requestBody);

            using var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString"));
            connection.Open();
            var query = $"EXEC DeleteLockManager '{lockId.LockId}';";
            using var command = new SqlCommand(query, connection);
            await command.ExecuteNonQueryAsync();
            return new OkResult();
        }
    }
}
