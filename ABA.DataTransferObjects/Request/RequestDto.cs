﻿using System;

namespace ABA.DataTransferObjects.Request
{
    public class RequestDto: RequestDetailsDto
    {
        public int? RequestId { get; set; }
        public int? LicenseId { get; set; }
        public string LicenseNumber { get; set; }
        public string CitizenIdnp { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int ActivityId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public DateTime? CreatedAt { get; set; }
        public int StatusId { get; set; }
        public byte NotifyExpiry { get; set; }
        public string Note { get; set; }
    }
}