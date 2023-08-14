using System;
using Microsoft.AspNetCore.Http;
using Microsoft.IdentityModel.Tokens;

namespace SDS.Function
{
    public static class AuthenticationManager
    {
        public static bool Authenticate(HttpRequest req)
        {
            var appUuid = req.Headers["appUuid"];
            var sid = req.Headers["sid"];
            return appUuid == Environment.GetEnvironmentVariable("ManagerAppUuid") && sid.IsNullOrEmpty();
        }
    }
}
