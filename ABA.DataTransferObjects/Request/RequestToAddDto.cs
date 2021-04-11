using System;
using System.Collections.Generic;

namespace ABA.DataTransferObjects.Request
{
    public class RequestToAddDto
    {
        public string CitizenIdnp { get; set; }
        public int ActivityId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public byte NotifyExpiry { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Note { get; set; }
        public bool PersonalDataAgreement { get; set; }
        public bool ObeyLawAgreement { get; set; }
        public List<int> Areas { get; set; }
        public List<int> Districts { get; set; }
        public List<int> Localities { get; set; }
    }
}