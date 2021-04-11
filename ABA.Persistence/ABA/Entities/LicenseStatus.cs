using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class LicenseStatus
    {
        public LicenseStatus()
        {
            Licenses = new HashSet<License>();
        }

        public int StatusId { get; set; }
        public string StatusName { get; set; }

        public virtual ICollection<License> Licenses { get; set; }
    }
}
