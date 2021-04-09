using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class Citizen
    {
        public Citizen()
        {
            Licenses = new HashSet<License>();
            Requests = new HashSet<Request>();
        }

        public string CitizenIdnp { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }

        public virtual ICollection<License> Licenses { get; set; }
        public virtual ICollection<Request> Requests { get; set; }
    }
}
