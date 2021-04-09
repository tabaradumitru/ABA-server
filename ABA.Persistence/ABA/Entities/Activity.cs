using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class Activity
    {
        public Activity()
        {
            Licenses = new HashSet<License>();
            Requests = new HashSet<Request>();
        }

        public int ActivityId { get; set; }
        public string ActivityName { get; set; }
        public byte RequiresLicense { get; set; }

        public virtual ICollection<License> Licenses { get; set; }
        public virtual ICollection<Request> Requests { get; set; }
    }
}
