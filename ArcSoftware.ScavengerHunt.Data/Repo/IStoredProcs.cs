using ArcSoftware.ScavengerHunt.Data.DbModels.EfModels;
using ArcSoftware.ScavengerHunt.Data.DbModels.SpModels;
using System;
using System.Collections.Generic;

namespace ArcSoftware.ScavengerHunt.Data.Repo
{
    public interface IStoredProcs
    {
        IEnumerable<SpApiLog> GetSpApiLogs(DateTime? startDate, DateTime? endDate);
        void PostApiLog(ApiLog apiLog);
    }
}
