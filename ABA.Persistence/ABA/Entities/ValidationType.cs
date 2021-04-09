using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class ValidationType
    {
        public ValidationType()
        {
            MconnectValidations = new HashSet<MconnectValidation>();
        }

        public int ValidationTypeId { get; set; }
        public string ValidationTypeName { get; set; }

        public virtual ICollection<MconnectValidation> MconnectValidations { get; set; }
    }
}
