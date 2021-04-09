using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class RegionalDirection
    {
        public RegionalDirection()
        {
            PoliceSectors = new HashSet<PoliceSector>();
        }

        public int RegionalDirectionId { get; set; }
        public int AreaId { get; set; }
        public string RegionalDirectionName { get; set; }

        public virtual Area Area { get; set; }
        public virtual ICollection<PoliceSector> PoliceSectors { get; set; }
    }
}
