using System;
using System.Collections.Generic;

#nullable disable

namespace ABA.Persistence.ABA.Entities
{
    public partial class Request
    {
        public Request()
        {
            Licenses = new HashSet<License>();
            MconnectValidations = new HashSet<MconnectValidation>();
            RequestLocalities = new HashSet<RequestLocality>();
            RequestReceivingMethods = new HashSet<RequestReceivingMethod>();
        }

        public int RequestId { get; set; }
        public string CitizenIdnp { get; set; }
        public int ActivityId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public DateTime CreatedAt { get; set; }
        public int StatusId { get; set; }
        public string Note { get; set; }
        public byte NotifyExpiry { get; set; }

        public virtual Activity Activity { get; set; }
        public virtual Citizen CitizenIdnpNavigation { get; set; }
        public virtual RequestStatus Status { get; set; }
        public virtual ICollection<License> Licenses { get; set; }
        public virtual ICollection<MconnectValidation> MconnectValidations { get; set; }
        public virtual ICollection<RequestLocality> RequestLocalities { get; set; }
        public virtual ICollection<RequestReceivingMethod> RequestReceivingMethods { get; set; }
    }
}
