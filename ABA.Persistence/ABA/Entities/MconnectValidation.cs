using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class MconnectValidation
    {
        public int MconnectValidationId { get; set; }
        public int RequestId { get; set; }
        public int ValidationTypeId { get; set; }
        public string ValidationValue { get; set; }

        public virtual Request Request { get; set; }
        public virtual ValidationType ValidationType { get; set; }
    }
}
