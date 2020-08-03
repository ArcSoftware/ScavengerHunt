using System;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class UserGpsLog
    {
        public int Id { get; set; }
        public int UserKey { get; set; }
        public DateTime GpsTimestamp { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }

        public virtual UserProfile UserKeyNavigation { get; set; }
    }
}