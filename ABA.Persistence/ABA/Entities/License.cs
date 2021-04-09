using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class License
    {
        public License()
        {
            LicenseLocalities = new HashSet<LicenseLocality>();
        }

        public int LicenseId { get; set; }
        public int RequestId { get; set; }
        public string EmployeeIdnp { get; set; }
        public string LicenseNumber { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CitizenIdnp { get; set; }
        public int ActivityId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }

        public virtual Activity Activity { get; set; }
        public virtual Citizen CitizenIdnpNavigation { get; set; }
        public virtual Employee EmployeeIdnpNavigation { get; set; }
        public virtual Request Request { get; set; }
        public virtual ICollection<LicenseLocality> LicenseLocalities { get; set; }
    }
}
