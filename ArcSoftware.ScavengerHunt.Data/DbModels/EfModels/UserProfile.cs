namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class UserProfile
    {
        public int Id { get; set; }
        public string UserId { get; set; }
        public string Email { get; set; }
        public bool? IsActive { get; set; }
    }
}