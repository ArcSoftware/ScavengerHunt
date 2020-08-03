using System;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class UserDeviceLog
    {
        public int Id { get; set; }
        public int UserKey { get; set; }
        public DateTime InitialConnectDate { get; set; }
        public decimal LastLat { get; set; }
        public decimal LastLong { get; set; }
        public int? PlatformKey { get; set; }

        public virtual Platform PlatformKeyNavigation { get; set; }
        public virtual UserProfile UserKeyNavigation { get; set; }
    }
}