﻿using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class ReceivingMethod
    {
        public ReceivingMethod()
        {
            LicenseReceivingMethods = new HashSet<LicenseReceivingMethod>();
            RequestReceivingMethods = new HashSet<RequestReceivingMethod>();
        }

        public int ReceivingMethodId { get; set; }
        public string ReceivingMethodName { get; set; }
        public byte IsRequired { get; set; }

        public virtual ICollection<LicenseReceivingMethod> LicenseReceivingMethods { get; set; }
        public virtual ICollection<RequestReceivingMethod> RequestReceivingMethods { get; set; }
    }
}
