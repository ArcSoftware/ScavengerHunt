using System.Collections.Generic;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class LogSeverity
    {
        public LogSeverity()
        {
            ApiLog = new HashSet<ApiLog>();
        }

        public int Id { get; set; }
        public string SeverityDesc { get; set; }

        public virtual ICollection<ApiLog> ApiLog { get; set; }
    }
}