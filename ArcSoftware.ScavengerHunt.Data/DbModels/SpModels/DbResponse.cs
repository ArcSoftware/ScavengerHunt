using System.ComponentModel.DataAnnotations;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.SpModels
{
    public class DbResponse
    {
        [Key]
        public bool Successful { get; set; }
        public string Message { get; set; }
    }
}