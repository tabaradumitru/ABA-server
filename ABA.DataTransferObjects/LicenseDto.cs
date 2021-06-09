using System;
using System.Collections.Generic;
using ABA.DataTransferObjects.Request;

namespace ABA.DataTransferObjects
{
    public class LicenseDto
    {
        public int LicenseId { get; set; }
        public string LicenseNumber { get; set; }
        public string CitizenIdnp { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int ActivityId { get; set; }
        public int StatusId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Note { get; set; }
        public byte NotifyExpiry { get; set; }
        public List<MappedReceivingMethodDto> ReceivingMethods { get; set; }
        public List<int> Areas { get; set; }
        public List<int> Districts { get; set; }
        public List<int> Localities { get; set; }
    }
}