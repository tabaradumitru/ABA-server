using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class RequestMconnectValidation
    {
        public int Id { get; set; }
        public int RequestId { get; set; }
        public int MconnectValidationId { get; set; }

        public virtual MconnectValidation MconnectValidation { get; set; }
        public virtual Request Request { get; set; }
    }
}
