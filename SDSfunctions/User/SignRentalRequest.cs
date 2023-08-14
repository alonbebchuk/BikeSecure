
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Data.SqlClient;
using System;
using System.Security.Cryptography;
using System.Text;
using System.IO;
using Newtonsoft.Json;

namespace SDS.Function
{
    public static class SignRentalRequest
    {
        public enum RentalFunctions
        {
            EndRental = 0,
            StartRental = 1
        }

        public class RentalRequest
        {
            public Guid LockId { get; set; }
            public int RequestCode { get; set; }
        }

        public class SignedRentalRequest
        {
            public string UserId { get; set; }
            public Guid LockId { get; set; }
            public string Url { get; set; }
            public string Mac { get; set; }
            public int RequestCode { get; set; }
            public DateTime RequestDateTime { get; set; }
            public string Signature { get; set; }
        }

        [FunctionName("SignRentalRequest")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "rentals/action")] HttpRequest req
        )
        {
            if (!Authentication.Authenticate(req))
            {
                return new BadRequestResult();
            }

            var requestBody = string.Empty;
            using (var streamReader = new StreamReader(req.Body))
            {
                requestBody = await streamReader.ReadToEndAsync();
            }
            var rentalRequest = JsonConvert.DeserializeObject<RentalRequest>(requestBody);

            if (!Enum.IsDefined(typeof(RentalFunctions), rentalRequest.RequestCode))
            {
                return new BadRequestResult();
            }

            var sid = req.Headers["sid"];
            using var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString"));
            connection.Open();
            var declarations = @"
                DECLARE @url NVARCHAR(MAX);
                DECLARE @mac NVARCHAR(MAX);
                DECLARE @secret BINARY(128);
            ";
            var procedure = $"EXEC {(RentalFunctions)rentalRequest.RequestCode} '{sid}', '{rentalRequest.LockId}', @url OUTPUT, @mac OUTPUT, @secret OUTPUT;";
            var select = "SELECT @url, @secret, @mac;";
            var query = declarations + procedure + select;
            using var command = new SqlCommand(query, connection);
            using var reader = await command.ExecuteReaderAsync();
            await reader.ReadAsync();
            var signedRentalRequest = new SignedRentalRequest
            {
                UserId = sid,
                LockId = rentalRequest.LockId,
                Url = reader.GetString(0),
                Mac = reader.GetString(2),
                RequestCode = rentalRequest.RequestCode,
                RequestDateTime = DateTime.UtcNow
            };

            var secret = new byte[128];
            reader.GetBytes(1, 0, secret, 0, 128);
            using var hmac = new HMACSHA512(secret);
            var signatureBytes = await hmac.ComputeHashAsync(
                new MemoryStream(
                    Encoding.UTF8.GetBytes(
                        signedRentalRequest.UserId +
                        signedRentalRequest.LockId +
                        signedRentalRequest.Url +
                        signedRentalRequest.Mac +
                        signedRentalRequest.RequestCode +
                        signedRentalRequest.RequestDateTime.ToString("O")
                    )
                )
            );
            signedRentalRequest.Signature = BitConverter.ToString(signatureBytes).Replace("-", "").ToLower();

            return new OkObjectResult(signedRentalRequest);
        }
    }
}
