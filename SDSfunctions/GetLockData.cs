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
    public static class GetLockData
    {
        public enum RentalStatuses
        {
            Available = 0,
            Owned = 1,
            Unavailable = -1
        }

        public class LockData
        {
            public string LockStatus { get; set; }
            public int LockId { get; set; }
            public string StationName { get; set; }
            public decimal? LocationLatitude { get; set; }
            public decimal? LocationLongitude { get; set; }
            public decimal? HourlyRate { get; set; }
            public DateTime? RentalStartTime { get; set; }
            public DateTime? RentalEndTime { get; set; }
            public TimeSpan? RentalDuration { get; set; }
            public decimal? TotalCost { get; set; }
        }

        [FunctionName("GetLockData")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "locks/data/{lockId:int}")] HttpRequest req,
            int lockId,
            ILogger log)
        {
            var sid = req.Headers["sid"];
            if (string.IsNullOrEmpty(sid)) {
                return new BadRequestResult();
            }

            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                var query = $"SELECT * FROM GetLockData('{sid}', {lockId});";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        await reader.ReadAsync();
                        var lockStatus = (RentalStatuses)reader.GetInt32(0);
                        var lockData = new LockData
                        {
                            LockStatus = lockStatus.ToString(),
                            LockId = reader.GetInt32(1)
                        };
                        if (lockStatus != RentalStatuses.Unavailable) {
                            lockData.StationName = reader.GetString(2);
                            lockData.LocationLatitude = reader.GetDecimal(3);
                            lockData.LocationLongitude = reader.GetDecimal(4);
                            lockData.HourlyRate = reader.GetDecimal(5);
                            if (lockStatus == RentalStatuses.Owned)
                            {
                                lockData.RentalStartTime = reader.GetDateTime(6);
                                lockData.RentalEndTime = reader.GetDateTime(7);
                                lockData.RentalDuration = lockData.RentalEndTime - lockData.RentalStartTime;
                                lockData.TotalCost = (int)lockData.RentalDuration.Value.TotalHours * lockData.HourlyRate;
                            }
                        }
                        return new OkObjectResult(lockData);
                    }
                }
            }
        }
    }
}
