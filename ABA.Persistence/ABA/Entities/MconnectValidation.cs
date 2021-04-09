using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class MconnectValidation
    {
        public MconnectValidation()
        {
            RequestMconnectValidations = new HashSet<RequestMconnectValidation>();
        }

        public int MconnectValidationId { get; set; }
        public int ValidationTypeId { get; set; }
        public string ValidationValue { get; set; }

        public virtual ValidationType ValidationType { get; set; }
        public virtual ICollection<RequestMconnectValidation> RequestMconnectValidations { get; set; }
    }
}
