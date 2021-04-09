using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class Area
    {
        public Area()
        {
            Districts = new HashSet<District>();
            RegionalDirections = new HashSet<RegionalDirection>();
        }

        public int AreaId { get; set; }
        public string AreaName { get; set; }

        public virtual ICollection<District> Districts { get; set; }
        public virtual ICollection<RegionalDirection> RegionalDirections { get; set; }
    }
}
