using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class LicenseReceivingMethod
    {
        public int Id { get; set; }
        public int LicenseId { get; set; }
        public int ReceivingMethodId { get; set; }
        public string ReceivingMethodValue { get; set; }

        public virtual License License { get; set; }
        public virtual ReceivingMethod ReceivingMethod { get; set; }
    }
}
