using System;
using System.Collections.Generic;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class Hunt
    {
        public Hunt()
        {
            Challenge = new HashSet<Challenge>();
        }

        public int Id { get; set; }
        public string HuntName { get; set; }
        public int? CreateUserKey { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime? LastLoadDate { get; set; }
        public bool? IsActive { get; set; }

        public virtual UserProfile CreateUserKeyNavigation { get; set; }
        public virtual ICollection<Challenge> Challenge { get; set; }
    }
}