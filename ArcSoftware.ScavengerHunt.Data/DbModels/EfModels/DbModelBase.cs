using System.ComponentModel.DataAnnotations;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public class DbModelBase
    {
        [Key]
        public int Id { get; set; }
        public bool IsActive { get; set; }
    }
}