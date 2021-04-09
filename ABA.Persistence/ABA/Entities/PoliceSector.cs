using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class PoliceSector
    {
        public int PoliceSectorId { get; set; }
        public string PoliceSectorName { get; set; }
        public int RegionalDirectionId { get; set; }

        public virtual RegionalDirection RegionalDirection { get; set; }
    }
}
