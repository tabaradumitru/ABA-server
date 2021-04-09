using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using ABA.Persistence.ABA.Entities;

#nullable disable

namespace ABA.Persistence.ABA
{
    public partial class ABADbContext : DbContext
    {
        public ABADbContext()
        {
        }

        public ABADbContext(DbContextOptions<ABADbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Activity> Activities { get; set; }
        public virtual DbSet<Area> Areas { get; set; }
        public virtual DbSet<Citizen> Citizens { get; set; }
        public virtual DbSet<District> Districts { get; set; }
        public virtual DbSet<Employee> Employees { get; set; }
        public virtual DbSet<EmployeeTitle> EmployeeTitles { get; set; }
        public virtual DbSet<License> Licenses { get; set; }
        public virtual DbSet<LicenseLocality> LicenseLocalities { get; set; }
        public virtual DbSet<Locality> Localities { get; set; }
        public virtual DbSet<MconnectValidation> MconnectValidations { get; set; }
        public virtual DbSet<PoliceSector> PoliceSectors { get; set; }
        public virtual DbSet<ReceivingMethod> ReceivingMethods { get; set; }
        public virtual DbSet<RegionalDirection> RegionalDirections { get; set; }
        public virtual DbSet<Request> Requests { get; set; }
        public virtual DbSet<RequestLocality> RequestLocalities { get; set; }
        public virtual DbSet<RequestMconnectValidation> RequestMconnectValidations { get; set; }
        public virtual DbSet<RequestReceivingMethod> RequestReceivingMethods { get; set; }
        public virtual DbSet<RequestStatus> RequestStatuses { get; set; }
        public virtual DbSet<ValidationType> ValidationTypes { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseMySQL("Server=localhost;Port=3306;Database=aba;User=dumitrutabara;Password=1317;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Activity>(entity =>
            {
                entity.ToTable("activity");

                entity.HasIndex(e => e.ActivityName, "activity_Name_uindex")
                    .IsUnique();

                entity.Property(e => e.ActivityName)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<Area>(entity =>
            {
                entity.ToTable("area");

                entity.Property(e => e.AreaName)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<Citizen>(entity =>
            {
                entity.HasKey(e => e.CitizenIdnp)
                    .HasName("PRIMARY");

                entity.ToTable("citizen");

                entity.HasIndex(e => e.CitizenIdnp, "Citizen_CitizenIDNP_uindex")
                    .IsUnique();

                entity.Property(e => e.CitizenIdnp)
                    .HasMaxLength(13)
                    .HasColumnName("CitizenIDNP");

                entity.Property(e => e.FirstName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<District>(entity =>
            {
                entity.ToTable("district");

                entity.HasIndex(e => e.AreaId, "district_area_AreaId_fk");

                entity.Property(e => e.DistrictName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.Area)
                    .WithMany(p => p.Districts)
                    .HasForeignKey(d => d.AreaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("district_area_AreaId_fk");
            });

            modelBuilder.Entity<Employee>(entity =>
            {
                entity.HasKey(e => e.EmployeeIdnp)
                    .HasName("PRIMARY");

                entity.ToTable("employee");

                entity.HasIndex(e => e.EmployeeTitleId, "employee_employee_title_EmployeeTitleId_fk");

                entity.Property(e => e.EmployeeIdnp)
                    .HasMaxLength(13)
                    .HasColumnName("EmployeeIDNP");

                entity.Property(e => e.FirstName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.EmployeeTitle)
                    .WithMany(p => p.Employees)
                    .HasForeignKey(d => d.EmployeeTitleId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("employee_employee_title_EmployeeTitleId_fk");
            });

            modelBuilder.Entity<EmployeeTitle>(entity =>
            {
                entity.ToTable("employee_title");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<License>(entity =>
            {
                entity.ToTable("license");

                entity.HasIndex(e => e.LicenseNumber, "license_LicenseNumber_uindex")
                    .IsUnique();

                entity.HasIndex(e => e.ActivityId, "license_activity_ActivityId_fk");

                entity.HasIndex(e => e.CitizenIdnp, "license_citizen_CitizenIDNP_fk");

                entity.HasIndex(e => e.EmployeeIdnp, "license_employee_EmployeeIDNP_fk");

                entity.HasIndex(e => e.RequestId, "license_request_RequestId_fk");

                entity.Property(e => e.CitizenIdnp)
                    .IsRequired()
                    .HasMaxLength(13)
                    .HasColumnName("CitizenIDNP");

                entity.Property(e => e.CreatedAt).HasColumnType("date");

                entity.Property(e => e.EmployeeIdnp)
                    .IsRequired()
                    .HasMaxLength(13)
                    .HasColumnName("EmployeeIDNP");

                entity.Property(e => e.EndDate).HasColumnType("date");

                entity.Property(e => e.LicenseNumber)
                    .IsRequired()
                    .HasMaxLength(20);

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.HasOne(d => d.Activity)
                    .WithMany(p => p.Licenses)
                    .HasForeignKey(d => d.ActivityId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("license_activity_ActivityId_fk");

                entity.HasOne(d => d.CitizenIdnpNavigation)
                    .WithMany(p => p.Licenses)
                    .HasForeignKey(d => d.CitizenIdnp)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("license_citizen_CitizenIDNP_fk");

                entity.HasOne(d => d.EmployeeIdnpNavigation)
                    .WithMany(p => p.Licenses)
                    .HasForeignKey(d => d.EmployeeIdnp)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("license_employee_EmployeeIDNP_fk");

                entity.HasOne(d => d.Request)
                    .WithMany(p => p.Licenses)
                    .HasForeignKey(d => d.RequestId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("license_request_RequestId_fk");
            });

            modelBuilder.Entity<LicenseLocality>(entity =>
            {
                entity.ToTable("license_locality");

                entity.HasIndex(e => e.LicenseId, "license_locality_license_LicenseId_fk");

                entity.HasIndex(e => e.LocalityId, "license_locality_locality_LocalityId_fk");

                entity.HasOne(d => d.License)
                    .WithMany(p => p.LicenseLocalities)
                    .HasForeignKey(d => d.LicenseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("license_locality_license_LicenseId_fk");

                entity.HasOne(d => d.Locality)
                    .WithMany(p => p.LicenseLocalities)
                    .HasForeignKey(d => d.LocalityId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("license_locality_locality_LocalityId_fk");
            });

            modelBuilder.Entity<Locality>(entity =>
            {
                entity.ToTable("locality");

                entity.HasIndex(e => e.DistrictId, "locality_district_DistrictId_fk");

                entity.Property(e => e.LocalityName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.District)
                    .WithMany(p => p.Localities)
                    .HasForeignKey(d => d.DistrictId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("locality_district_DistrictId_fk");
            });

            modelBuilder.Entity<MconnectValidation>(entity =>
            {
                entity.ToTable("mconnect_validation");

                entity.HasIndex(e => e.ValidationTypeId, "mconnect_validation_validation_type_ValidationTypeId_fk");

                entity.Property(e => e.ValidationValue)
                    .IsRequired()
                    .HasMaxLength(1000);

                entity.HasOne(d => d.ValidationType)
                    .WithMany(p => p.MconnectValidations)
                    .HasForeignKey(d => d.ValidationTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("mconnect_validation_validation_type_ValidationTypeId_fk");
            });

            modelBuilder.Entity<PoliceSector>(entity =>
            {
                entity.ToTable("police_sector");

                entity.HasIndex(e => e.RegionalDirectionId, "police_sector_regional_direction_RegionalDirectionId_fk");

                entity.Property(e => e.PoliceSectorName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.RegionalDirection)
                    .WithMany(p => p.PoliceSectors)
                    .HasForeignKey(d => d.RegionalDirectionId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("police_sector_regional_direction_RegionalDirectionId_fk");
            });

            modelBuilder.Entity<ReceivingMethod>(entity =>
            {
                entity.ToTable("receiving_method");

                entity.Property(e => e.ReceivingMethodName).HasMaxLength(255);
            });

            modelBuilder.Entity<RegionalDirection>(entity =>
            {
                entity.ToTable("regional_direction");

                entity.HasIndex(e => e.AreaId, "regional_direction_area_AreaId_fk");

                entity.Property(e => e.RegionalDirectionName)
                    .IsRequired()
                    .HasMaxLength(255);

                entity.HasOne(d => d.Area)
                    .WithMany(p => p.RegionalDirections)
                    .HasForeignKey(d => d.AreaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("regional_direction_area_AreaId_fk");
            });

            modelBuilder.Entity<Request>(entity =>
            {
                entity.ToTable("request");

                entity.HasIndex(e => e.ActivityId, "request_activity_RequestId_fk");

                entity.HasIndex(e => e.CitizenIdnp, "request_citizen_CitizenIDNP_fk");

                entity.HasIndex(e => e.StatusId, "request_request_status_StatusId_fk");

                entity.Property(e => e.CitizenIdnp)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("CitizenIDNP");

                entity.Property(e => e.CreatedAt).HasColumnType("date");

                entity.Property(e => e.EndDate).HasColumnType("date");

                entity.Property(e => e.Note).HasMaxLength(2000);

                entity.Property(e => e.Phone).HasMaxLength(8);

                entity.Property(e => e.StartDate).HasColumnType("date");

                entity.HasOne(d => d.Activity)
                    .WithMany(p => p.Requests)
                    .HasForeignKey(d => d.ActivityId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("request_activity_RequestId_fk");

                entity.HasOne(d => d.CitizenIdnpNavigation)
                    .WithMany(p => p.Requests)
                    .HasForeignKey(d => d.CitizenIdnp)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("request_citizen_CitizenIDNP_fk");

                entity.HasOne(d => d.Status)
                    .WithMany(p => p.Requests)
                    .HasForeignKey(d => d.StatusId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("request_request_status_StatusId_fk");
            });

            modelBuilder.Entity<RequestLocality>(entity =>
            {
                entity.ToTable("request_locality");

                entity.HasIndex(e => e.LocalityId, "request_locality_locality_LocalityId_fk");

                entity.HasIndex(e => e.RequestId, "request_locality_request_RequestId_fk");

                entity.HasOne(d => d.Locality)
                    .WithMany(p => p.RequestLocalities)
                    .HasForeignKey(d => d.LocalityId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("request_locality_locality_LocalityId_fk");

                entity.HasOne(d => d.Request)
                    .WithMany(p => p.RequestLocalities)
                    .HasForeignKey(d => d.RequestId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("request_locality_request_RequestId_fk");
            });

            modelBuilder.Entity<RequestMconnectValidation>(entity =>
            {
                entity.ToTable("request_mconnect_validation");

                entity.HasIndex(e => e.MconnectValidationId, "request_mconnect_validation_mconnect_MconnectValidationId_fk");

                entity.HasIndex(e => e.RequestId, "request_mconnect_validation_request_RequestId_fk");

                entity.HasOne(d => d.MconnectValidation)
                    .WithMany(p => p.RequestMconnectValidations)
                    .HasForeignKey(d => d.MconnectValidationId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("request_mconnect_validation_mconnect_MconnectValidationId_fk");

                entity.HasOne(d => d.Request)
                    .WithMany(p => p.RequestMconnectValidations)
                    .HasForeignKey(d => d.RequestId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("request_mconnect_validation_request_RequestId_fk");
            });

            modelBuilder.Entity<RequestReceivingMethod>(entity =>
            {
                entity.ToTable("request_receiving_method");

                entity.HasIndex(e => e.ReceivingMethodId, "request_receiving_method_receiving_method_ReceivingMethodId_fk");

                entity.HasIndex(e => e.RequestId, "request_receiving_method_request_RequestId_fk");

                entity.Property(e => e.ReceivingMethodValue).HasMaxLength(255);

                entity.HasOne(d => d.ReceivingMethod)
                    .WithMany(p => p.RequestReceivingMethods)
                    .HasForeignKey(d => d.ReceivingMethodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("request_receiving_method_receiving_method_ReceivingMethodId_fk");

                entity.HasOne(d => d.Request)
                    .WithMany(p => p.RequestReceivingMethods)
                    .HasForeignKey(d => d.RequestId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("request_receiving_method_request_RequestId_fk");
            });

            modelBuilder.Entity<RequestStatus>(entity =>
            {
                entity.HasKey(e => e.StatusId)
                    .HasName("PRIMARY");

                entity.ToTable("request_status");

                entity.Property(e => e.StatusName)
                    .IsRequired()
                    .HasMaxLength(20);
            });

            modelBuilder.Entity<ValidationType>(entity =>
            {
                entity.ToTable("validation_type");

                entity.Property(e => e.ValidationTypeName)
                    .IsRequired()
                    .HasMaxLength(255);
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
