using System;
using ArcSoftware.ScavengerHunt.Data.Enums;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class ApiLog
    {
        public int Id { get; set; }
        public DateTime LogDate { get; set; }
        public int LogTypeKey { get; set; }
        public int SeverityKey { get; set; }
        public int PlatformKey { get; set; }
        public string AppVersion { get; set; }
        public string RouteDesc { get; set; }
        public int UserKey { get; set; }
        public string LogMessage { get; set; }

        public virtual LogType LogTypeKeyNavigation { get; set; }
        public virtual Platform PlatformKeyNavigation { get; set; }
        public virtual LogSeverity SeverityKeyNavigation { get; set; }
        public virtual UserProfile UserKeyNavigation { get; set; }

        public ApiLog()
        {
        }

        public ApiLog(LoggingType logType, LoggingSeverity logSeverity, LoggingPlatform platform, string routeDesc, string appVersion, int userKey, string logMessage)
        {
            Id = 0;
            LogDate = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow,
                TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time"));
            LogTypeKey = (int) logType;
            SeverityKey = (int) logSeverity;
            PlatformKey = (int) platform;
            RouteDesc = routeDesc;
            AppVersion = appVersion;
            UserKey = userKey == 0 ? 1 : userKey;
            LogMessage = logMessage;
        }
    }
}