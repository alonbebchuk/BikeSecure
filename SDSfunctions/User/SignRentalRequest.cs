
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

namespace SDS.Function
{
    public static class SignRentalRequest
    {
        public enum RentalRequest
        {
            Start = 1,
            End = 0
        }

        public class SignedRentalRequest
        {
            public string UserId { get; set; }
            public Guid LockId { get; set; }
            public string Url { get; set; }
            public string Mac { get; set; }
            public int RequestCode { get; set; }
            public DateTime RequestDateTime { get; set; }
            public byte[] Signature { get; set; }
        }

        [FunctionName("SignRentalRequest")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "rentals/{request:alpha}/{lockId:guid}")] HttpRequest req,
            string request,
            Guid lockId
        )
        {
            if (!Enum.TryParse<RentalRequest>(request, true, out var rentalRequest))
            {
                return new BadRequestResult();
            }

            var sid = "user_413046ae5f07424db6ba9da0c4340a24";
            using var connection = new SqlConnection(Environment.GetEnvironmentVariable("SqlConnectionString"));
            connection.Open();
            var declarations = @"
                DECLARE @res BIT;
                DECLARE @url NVARCHAR(MAX);
                DECLARE @secret BINARY(128);
                DECLARE @mac NVARCHAR(MAX);
            ";
            var procedure = $"EXEC @res = {rentalRequest}Rental '{sid}', '{lockId}', @url OUTPUT, @secret OUTPUT, @mac OUTPUT;";
            var select = "SELECT @res, @url, @secret, @mac;";
            var query = declarations + procedure + select;
            using var command = new SqlCommand(query, connection);
            using var reader = await command.ExecuteReaderAsync();
            await reader.ReadAsync();
            var res = reader.GetBoolean(0);
            if (res)
            {
                var url = reader.GetString(1);
                var secret = new byte[128];
                reader.GetBytes(2, 0, secret, 0, 128);
                var mac = reader.GetString(3);
                var requestCode = (int)rentalRequest;
                var requestDateTime = DateTime.UtcNow;
                
                using var hmac = new HMACSHA512(secret);
                var signature = await hmac.ComputeHashAsync(
                    new MemoryStream(Encoding.UTF8.GetBytes(sid + lockId + url + mac + requestCode + requestDateTime))
                );

                var signedRentalRequest = new SignedRentalRequest
                {
                    UserId = sid,
                    LockId = lockId,
                    Url = url,
                    Mac = mac,
                    RequestCode = requestCode,
                    RequestDateTime = requestDateTime,
                    Signature = signature
                };

                return new OkObjectResult(signedRentalRequest);
            }
            return new BadRequestResult();
        }
    }
}
