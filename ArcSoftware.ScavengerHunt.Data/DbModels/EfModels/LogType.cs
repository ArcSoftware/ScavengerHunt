using System.Collections.Generic;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class LogType
    {
        public LogType()
        {
            ApiLog = new HashSet<ApiLog>();
        }

        public int Id { get; set; }
        public string TypeDesc { get; set; }

        public virtual ICollection<ApiLog> ApiLog { get; set; }
    }
}