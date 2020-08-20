using ArcSoftware.ScavengerHunt.Data.DbModels;
using ArcSoftware.ScavengerHunt.Data.DbModels.EfModels;
using ArcSoftware.ScavengerHunt.Data.DbModels.SpModels;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;

namespace ArcSoftware.ScavengerHunt.Data.Repo
{
    public class StoredProcs : IStoredProcs
    {
        private readonly ScavengerHuntContext _context;

        public StoredProcs(ScavengerHuntContext context)
        {
            _context = context;
        }

        public IEnumerable<SpApiLog> GetSpApiLogs(DateTime? startDate, DateTime? endDate)
        {
            return _context.SpApiLogs.FromSqlInterpolated($"dbo.spGet_ApiLogs {startDate}, {endDate}");
        }

        public void PostApiLog(ApiLog apiLog)
        {
            _context.Database.ExecuteSqlInterpolated($"exec dbo.spPost_ApiLog {apiLog.LogTypeKey}, {apiLog.SeverityKey}, {apiLog.PlatformKey}, {apiLog.RouteDesc}, {apiLog.AppVersion}, {apiLog.UserKey}, {apiLog.LogMessage}");
        }
    }
}