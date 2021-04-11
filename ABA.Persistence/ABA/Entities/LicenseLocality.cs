using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class LicenseLocality
    {
        public int Id { get; set; }
        public int LicenseId { get; set; }
        public int LocalityId { get; set; }

        public virtual License License { get; set; }
        public virtual Locality Locality { get; set; }
    }
}
