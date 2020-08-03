using System;
using System.ComponentModel.DataAnnotations;

namespace ArcSoftware.ScavengerHunt.Data.DbModels.SpModels
{
    public class SpApiLog
    {
        [Key]
        public int LogKey { get; set; }
        public DateTime LogDate { get; set; }
        public string Type { get; set; }
        public string Severity { get; set; }
        public string Platform { get; set; }
        public string RouteDesc { get; set; }
        public string AppVersion { get; set; }
        public int UserKey { get; set; }
        public string UserId { get; set; }
        public string LogMessage { get; set; }
    }
}