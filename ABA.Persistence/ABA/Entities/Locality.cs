using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class Locality
    {
        public Locality()
        {
            LicenseLocalities = new HashSet<LicenseLocality>();
            RequestLocalities = new HashSet<RequestLocality>();
        }

        public int LocalityId { get; set; }
        public string LocalityName { get; set; }
        public int DistrictId { get; set; }

        public virtual District District { get; set; }
        public virtual ICollection<LicenseLocality> LicenseLocalities { get; set; }
        public virtual ICollection<RequestLocality> RequestLocalities { get; set; }
    }
}
