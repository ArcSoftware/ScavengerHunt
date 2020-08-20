using ArcSoftware.ScavengerHunt.Data.DbModels.EfModels;
using ArcSoftware.ScavengerHunt.Data.DbModels.SpModels;
using Microsoft.EntityFrameworkCore;

namespace ArcSoftware.ScavengerHunt.Data.DbModels
{
    public partial class ScavengerHuntContext : DbContext
    {
        public ScavengerHuntContext()
        {
        }

        public ScavengerHuntContext(DbContextOptions<ScavengerHuntContext> options)
            : base(options)
        {
        }

        //EF
        public virtual DbSet<ApiLog> ApiLog { get; set; }
        public virtual DbSet<Challenge> Challenge { get; set; }
        public virtual DbSet<Hunt> Hunt { get; set; }
        public virtual DbSet<LogSeverity> LogSeverity { get; set; }
        public virtual DbSet<LogType> LogType { get; set; }
        public virtual DbSet<Platform> Platform { get; set; }
        public virtual DbSet<UserDeviceLog> UserDeviceLog { get; set; }
        public virtual DbSet<UserGpsLog> UserGpsLog { get; set; }
        public virtual DbSet<UserProfile> UserProfile { get; set; }

        //SP
        public virtual DbSet<DbResponse> DbResponse { get; set; }
        public virtual DbSet<SpApiLog> SpApiLogs { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //EF
            modelBuilder.Entity<ApiLog>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.AppVersion)
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.LogDate)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.LogMessage).IsUnicode(false);

                entity.Property(e => e.RouteDesc)
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.HasOne(d => d.LogTypeKeyNavigation)
                    .WithMany(p => p.ApiLog)
                    .HasForeignKey(d => d.LogTypeKey)
                    .HasConstraintName("FK__ApiLog__LogTypeK__3B40CD36");

                entity.HasOne(d => d.PlatformKeyNavigation)
                    .WithMany(p => p.ApiLog)
                    .HasForeignKey(d => d.PlatformKey)
                    .HasConstraintName("FK__ApiLog__Platform__3D2915A8");

                entity.HasOne(d => d.SeverityKeyNavigation)
                    .WithMany(p => p.ApiLog)
                    .HasForeignKey(d => d.SeverityKey)
                    .HasConstraintName("FK__ApiLog__Severity__3C34F16F");
            });

            modelBuilder.Entity<Challenge>(entity =>
            {
                entity.Property(e => e.ChallengeName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.Hint1)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.Hint2)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.IsActive)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.SolutionLat).HasColumnType("decimal(9, 6)");

                entity.Property(e => e.SolutionLong).HasColumnType("decimal(9, 6)");

                entity.Property(e => e.SolutionQr)
                    .HasColumnName("SolutionQR")
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.SolutionText)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Hunt>(entity =>
            {
                entity.Property(e => e.CreateDate)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.HuntName)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);

                entity.Property(e => e.IsActive)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.LastLoadDate).HasColumnType("datetime");
            });

            modelBuilder.Entity<LogSeverity>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.SeverityDesc)
                    .HasMaxLength(255)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<LogType>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.TypeDesc)
                    .HasMaxLength(255)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<Platform>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.PlatformDesc)
                    .HasMaxLength(255)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<UserDeviceLog>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.InitialConnectDate)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.LastLat).HasColumnType("decimal(9, 6)");

                entity.Property(e => e.LastLong).HasColumnType("decimal(9, 6)");

                entity.HasOne(d => d.PlatformKeyNavigation)
                    .WithMany(p => p.UserDeviceLog)
                    .HasForeignKey(d => d.PlatformKey)
                    .OnDelete(DeleteBehavior.Cascade)
                    .HasConstraintName("FK__UserDevic__Platf__2FCF1A8A");
            });

            modelBuilder.Entity<UserGpsLog>(entity =>
            {
                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.GpsTimestamp)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getdate())");

                entity.Property(e => e.Latitude).HasColumnType("decimal(9, 6)");

                entity.Property(e => e.Longitude).HasColumnType("decimal(9, 6)");
            });

            modelBuilder.Entity<UserProfile>(entity =>
            {
                entity.HasIndex(e => e.Email)
                    .HasName("ak_Email")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.IsActive)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.UserId)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);
            });

            //SP
            modelBuilder.Entity<DbResponse>(entity =>
            {
                entity.Property(e => e.Successful)
                    .HasColumnName("ErrorState");

                entity.Property(e => e.Message)
                    .HasColumnName("ErrorMessage");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
