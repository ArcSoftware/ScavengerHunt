using System;
using ArcSoftware.ScavengerHunt.Data.DbModels.EfModels;
using ArcSoftware.ScavengerHunt.Data.Enums;
using ArcSoftware.ScavengerHunt.Data.Repo;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace ArcSoftware.ScavengerHunt.Web.Controllers.Api
{
    public abstract class ApiControllerBase : Controller
    {
        private readonly IRepository _repo;
        private readonly IStoredProcs _sp;
        private readonly string _appVersion;

        protected ApiControllerBase(IConfiguration config, IRepository repo, IStoredProcs sp)
        {
            _repo = repo;
            _sp = sp;
            _appVersion = config.GetSection("AppVersion").Value;
        }

        protected virtual void Log(LoggingType logType, LoggingSeverity logSeverity, LoggingPlatform platform, 
            int? userKey, string logMessage)
        {
            _sp.PostApiLog(new ApiLog(logType, logSeverity, platform, HttpContext.Request.Path.Value, _appVersion,
                userKey ?? 1, logMessage));
        }

        protected virtual void LogInfo(int? userKey, LoggingSeverity logSeverity, string logMessage)
        {
            _sp.PostApiLog(new ApiLog(LoggingType.Info, logSeverity, LoggingPlatform.Api, HttpContext.Request.Path.Value,
                _appVersion,  userKey ?? 1, logMessage));
        }

        protected virtual void LogApiException(int? userKey, Exception e)
        {
            _sp.PostApiLog(new ApiLog(LoggingType.Error, LoggingSeverity.Critical, LoggingPlatform.Api,
                HttpContext.Request.Path.Value, _appVersion, userKey ?? 1, e.Message + e.InnerException));
        }
    }
}
