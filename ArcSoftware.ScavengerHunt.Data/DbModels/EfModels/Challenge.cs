namespace ArcSoftware.ScavengerHunt.Data.DbModels.EfModels
{
    public partial class Challenge
    {
        public int Id { get; set; }
        public string ChallengeName { get; set; }
        public int HuntKey { get; set; }
        public string Hint1 { get; set; }
        public string Hint2 { get; set; }
        public string SolutionText { get; set; }
        public string SolutionQr { get; set; }
        public decimal? SolutionLat { get; set; }
        public decimal? SolutionLong { get; set; }
        public bool? IsActive { get; set; }

        public virtual Hunt HuntKeyNavigation { get; set; }
    }
}