using System;
using Microsoft.AspNetCore.Http;

namespace SDS.Function
{
    public static class Authentication
    {
        public static bool Authenticate(HttpRequest req)
        {
            var appUuid = req.Headers["appUuid"];
            var sid = req.Headers["sid"];
            return appUuid == Environment.GetEnvironmentVariable("UserAppUuid") && !string.IsNullOrEmpty(sid);
        }
    }
}
