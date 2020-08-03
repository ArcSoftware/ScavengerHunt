using System.Collections.Generic;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class Platform
    {
        public Platform()
        {
            ApiLog = new HashSet<ApiLog>();
            UserDeviceLog = new HashSet<UserDeviceLog>();
        }

        public int Id { get; set; }
        public string PlatformDesc { get; set; }

        public virtual ICollection<ApiLog> ApiLog { get; set; }
        public virtual ICollection<UserDeviceLog> UserDeviceLog { get; set; }
    }
}