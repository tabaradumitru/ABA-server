using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class RequestReceivingMethod
    {
        public int Id { get; set; }
        public int RequestId { get; set; }
        public int ReceivingMethodId { get; set; }
        public string ReceivingMethodValue { get; set; }

        public virtual ReceivingMethod ReceivingMethod { get; set; }
        public virtual Request Request { get; set; }
    }
}
