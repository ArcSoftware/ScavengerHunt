using System.Collections.Generic;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class UserProfile
    {
        public UserProfile()
        {
            ApiLog = new HashSet<ApiLog>();
            Hunt = new HashSet<Hunt>();
            UserDeviceLog = new HashSet<UserDeviceLog>();
            UserGpsLog = new HashSet<UserGpsLog>();
        }

        public int Id { get; set; }
        public string UserId { get; set; }
        public string Email { get; set; }
        public bool? IsActive { get; set; }

        public virtual ICollection<ApiLog> ApiLog { get; set; }
        public virtual ICollection<Hunt> Hunt { get; set; }
        public virtual ICollection<UserDeviceLog> UserDeviceLog { get; set; }
        public virtual ICollection<UserGpsLog> UserGpsLog { get; set; }
    }
}