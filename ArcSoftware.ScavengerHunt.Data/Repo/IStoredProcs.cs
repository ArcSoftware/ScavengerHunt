using ArcSoftware.ScavengerHunt.Data.DbModels.EfModels;
using ArcSoftware.ScavengerHunt.Data.DbModels.SpModels;
using System;
using System.Collections.Generic;

namespace ArcSoftware.ScavengerHunt.Data.Repo
{
    public interface IStoredProcs
    {
        IEnumerable<SpApiLog> GetSpApiLogs(DateTime? startDate, DateTime? endDate, int? userKey);
        void PostApiLog(ApiLog apiLog);
    }
}
