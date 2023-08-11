using System;
using System.IO;
using Newtonsoft.Json;
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
    public static class AddStationManager
    {
        public class StationData
        {
            public string Name { get; set; }
            public decimal HourlyRate { get; set; }
            public decimal Latitude { get; set; }
            public decimal Longitude { get; set; }
            public string Url { get; set; }
        }

        [FunctionName("AddStationManager")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "manage/stations/add")] HttpRequest req
        )
        {
            var requestBody = String.Empty;
            using (StreamReader streamReader = new StreamReader(req.Body))
            {
                requestBody = await streamReader.ReadToEndAsync();
            }
            var stationData = JsonConvert.DeserializeObject<StationData>(requestBody);

            using (var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString")))
            {
                connection.Open();
                var query = $"EXEC AddStationManager {stationData.Name}, {stationData.HourlyRate}, {stationData.Latitude}, {stationData.Longitude}, {stationData.Url};";
                using (var command = new SqlCommand(query, connection))
                {
                    await command.ExecuteNonQueryAsync();
                    return new OkResult();
                }
            }
        }
    }
}
