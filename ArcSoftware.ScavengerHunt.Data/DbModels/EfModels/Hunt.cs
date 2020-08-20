using System;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class Hunt : DbModelBase
    {
        public string HuntName { get; set; }
        public int CreateUserKey { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime? LastLoadDate { get; set; }

        public Hunt()
        {
        }

        public Hunt(string huntName, int userKey)
        {
            HuntName = huntName;
            CreateUserKey = userKey;
            CreateDate = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow,
                TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time"));
        }

        public override string ToString() =>
            $"[{HuntName}, active: {IsActive}]";
    }
}