using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class District
    {
        public District()
        {
            Localities = new HashSet<Locality>();
        }

        public int DistrictId { get; set; }
        public string DistrictName { get; set; }
        public int AreaId { get; set; }

        public virtual Area Area { get; set; }
        public virtual ICollection<Locality> Localities { get; set; }
    }
}
