using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Collections.Generic;
using System.IO;
using Newtonsoft.Json;
using Microsoft.Data.SqlClient;
using System.Data;

namespace SDS.Function
{
    public static class Functions
    {
        #region Common Variables
        public static string connectionString = Environment.GetEnvironmentVariable("SqlConnectionString");
        public static Guid userId = new Guid("11111111-1111-1111-1111-111111111111");
        public static Guid lockId = new Guid("11111111-1111-1111-1111-111111111111");
        public static int processId = 1;
        public static Guid parkingProcessId = new Guid("41024099-D9BC-4295-8BBB-71D30443759F");
        public static double rate = 0.01;
        public static List<string> states = new List<string> { "Locked", "Unlocked" };
        #endregion

        #region Common Functions
        public static string ConditionalQuery(string conditionQuery)
        {
            return $"SELECT CASE WHEN EXISTS ({conditionQuery}) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END";
        }

        public static async Task<dynamic> GetBody(HttpRequest req)
        {
            var content = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic body = JsonConvert.DeserializeObject(content);
            return body;
        }

        public static async Task ExecuteNonQuery(string sqlCommand)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (var command = new SqlCommand(sqlCommand, connection))
                {
                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public static async Task<object> ExecuteScalar(string sqlCommand)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (var command = new SqlCommand(sqlCommand, connection))
                {
                    Console.Write(command.CommandText);
                    return await command.ExecuteScalarAsync();
                }
            }
        }

        public static async Task<IEnumerable<T>> ExecuteReader<T>(Func<IDataReader, T> builder, string sqlCommand)
        {
            var items = new List<T>();
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (var command = new SqlCommand(sqlCommand, connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            items.Add(builder(reader));
                        }
                    }
                }
            }
            return items;
        }
        #endregion

        #region Models
        public class UserItem
        {
            public Guid id { get; set; }
            public decimal balance { get; set; }
            public decimal tab { get; set; }
        }

        public class TransactionItem
        {
            public int id { get; set; }
            public Guid userId { get; set; }
            public DateTime dateTime { get; set; }
            public decimal amount { get; set; }
        }

        public class LockItem
        {
            public Guid id { get; set; }
            public Guid ownerId { get; set; }
            public string state { get; set; }
        }

        public class ParkingProcessItem
        {
            public int id { get; set; }
            public Guid userId { get; set; }
            public Guid lockId { get; set; }
            public DateTime startTime { get; set; }
            public DateTime endTime { get; set; }
            public int duration { get; set; }
            public decimal cost { get; set; }
        }
        #endregion

        // GET: { "user_id": guid }
        // Returns UserItem
        [FunctionName("GetUser")]
        public static async Task<IActionResult> GetUser(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log
        )
        {
            var body = await GetBody(req);
            var user = (await ExecuteReader<UserItem>(
                (dataReader) => new UserItem
                {
                    id = dataReader.GetGuid(0),
                    balance = dataReader.GetDecimal(1),
                    tab = dataReader.GetDecimal(2)
                },
                $"SELECT * FROM GetUser('{body.user_id}')"
            )).FirstOrDefault();
            return new OkObjectResult(user);
        }

        // POST: { "user_id": guid }
        [FunctionName("AddUserIfNotExists")]
        public static async Task<IActionResult> AddUserIfNotExists(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log
        )
        {
            var body = await GetBody(req);
            await ExecuteNonQuery($"EXEC InsertUserIfNotExists '{body.user_id}'");
            return new OkResult();
        }

        // POST: Body { "user_id": guid, "amount": decimal }
        [FunctionName("LoadUserBalance")]
        public static async Task<IActionResult> LoadUserBalance(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log
        )
        {
            var body = await GetBody(req);
            await ExecuteNonQuery($"EXEC LoadUserBalance '{body.user_id}', {body.amount}");
            return new OkResult();
        }

        // GET: Body { "user_id": guid }
        // Returns IEnumerable<TransactionItem>
        [FunctionName("GetUserTransactions")]
        public static async Task<IActionResult> GetUserTransactions(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log
        )
        {
            var body = await GetBody(req);
            var userTransactions = await ExecuteReader(
                (dataReader) => new TransactionItem
                {
                    id = dataReader.GetInt32(0),
                    userId = dataReader.GetGuid(1),
                    dateTime = dataReader.GetDateTime(2),
                    amount = dataReader.GetDecimal(3)
                },
                $"SELECT * FROM GetUserTransactions('{body.user_id}') ORDER BY date_time DESC"
            );
            return new OkObjectResult(userTransactions);
        }

        // GET: Body { "lock_id": guid }
        // Returns LockItem
        [FunctionName("GetLock")]
        public static async Task<IActionResult> GetLock(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log
        )
        {
            var body = await GetBody(req);
            var lockItem = (await ExecuteReader<LockItem>(
                (dataReader) => new LockItem
                {
                    id = dataReader.GetGuid(0),
                    ownerId = dataReader.GetGuid(1),
                    state = dataReader.GetString(2)
                },
                $"SELECT * FROM GetLock('{body.lock_id}')"
            )).FirstOrDefault();
            return new OkObjectResult(lockItem);
        }

        // POST: Route "state" string, Body { "user_id": guid, "lock_Id": guid }
        // Returns boolean
        [FunctionName("TryChangeLockState")]
        public static async Task<IActionResult> TryChangeLockState(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = "TryChangeLockState/{state:alpha}")] HttpRequest req,
            string state,
            ILogger log
        )
        {
            var body = await GetBody(req);
            var success = (bool)await ExecuteScalar(
                $@"BEGIN
                    DECLARE @success BIT
                    EXEC TryChangeLockState '{body.user_id}', '{body.lock_id}', '{state}', @success OUTPUT
                    SELECT @success
                END"
            );
            return new OkObjectResult(success);
        }

        // GET: Body { "user_id": guid, "lock_id": guid }
        // Returns int
        [FunctionName("TryStartParkingProcess")]
        public static async Task<IActionResult> TryStartParkingProcess(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log
        )
        {
            var body = await GetBody(req);
            var processId = (int)await ExecuteScalar(
                $@"BEGIN
                    DECLARE @parking_process_id INT
                    EXEC TryStartParkingProcess '{body.user_id}', '{body.lock_id}', @parking_process_id OUTPUT
                    SELECT @parking_process_id
                END"
            );
            return new OkObjectResult(processId);
        }

        // GET: Body { "user_id": guid, "process_id": guid }
        // Returns boolean
        [FunctionName("TryStopParkingProcess")]
        public static async Task<IActionResult> TryStopParkingProcess(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log
        )
        {
            var body = await GetBody(req);
            var success = (bool)await ExecuteScalar(
                $@"BEGIN
                    DECLARE @success BIT
                    EXEC TryStopParkingProcess '{body.user_id}', '{body.process_id}', {rate}, @success OUTPUT
                    SELECT @success
                END"
            );
            return new OkObjectResult(success);
        }

        // GET: Body { "user_id": guid }
        // Returns IEnumerable<ParkingProcessItem>
        [FunctionName("GetUserCurrentParkingProcesses")]
        public static async Task<IActionResult> GetUserCurrentParkingProcesses(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log
        )
        {
            var body = await GetBody(req);
            var userCurrentParkingProcesses = await ExecuteReader(
                (dataReader) => new ParkingProcessItem
                {
                    id = dataReader.GetInt32(0),
                    userId = dataReader.GetGuid(1),
                    lockId = dataReader.GetGuid(2),
                    startTime = dataReader.GetDateTime(3)
                },
                $"SELECT * FROM GetUserCurrentParkingProcesses('{body.user_id}') ORDER BY start_time DESC"
            );
            return new OkObjectResult(userCurrentParkingProcesses);
        }

        // GET: Body { "user_id": guid }
        // Returns IEnumerable<ParkingProcessItem>
        [FunctionName("GetUserPastParkingProcesses")]
        public static async Task<IActionResult> GetUserPastParkingProcesses(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log
        )
        {
            var body = await GetBody(req);
            var userPastParkingProcesses = await ExecuteReader(
                (dataReader) => new ParkingProcessItem
                {
                    id = dataReader.GetInt32(0),
                    userId = dataReader.GetGuid(1),
                    lockId = dataReader.GetGuid(2),
                    startTime = dataReader.GetDateTime(3),
                    endTime = dataReader.GetDateTime(4),
                    duration = dataReader.GetInt32(5),
                    cost = dataReader.GetDecimal(6)
                },
                $"SELECT * FROM GetUserPastParkingProcesses('{body.user_id}') ORDER BY end_time DESC"
            );
            return new OkObjectResult(userPastParkingProcesses);
        }
    }
}
