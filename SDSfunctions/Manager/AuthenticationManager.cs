using System;
using Microsoft.AspNetCore.Http;

namespace SDS.Function
{
    public static class AuthenticationManager
    {
        public static bool Authenticate(HttpRequest req)
        {
            var appUuid = req.Headers["appUuid"];
            return appUuid == Environment.GetEnvironmentVariable("ManagerAppUuid");
        }
    }
}
