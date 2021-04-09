using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class RequestLocality
    {
        public int Id { get; set; }
        public int RequestId { get; set; }
        public int LocalityId { get; set; }

        public virtual Locality Locality { get; set; }
        public virtual Request Request { get; set; }
    }
}
