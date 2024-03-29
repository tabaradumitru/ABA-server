﻿using System.Collections.Generic;

namespace ABA.DataTransferObjects.Request
{
    public class RequestDetailsDto
    {
        public List<MappedReceivingMethodDto> ReceivingMethods { get; set; }
        public byte NotifyExpiry { get; set; }
        public string Email { get; set; }
        public bool PersonalDataAgreement { get; set; }
        public bool ObeyLawAgreement { get; set; }
        public List<int> Areas { get; set; }
        public List<int> Districts { get; set; }
        public List<int> Localities { get; set; }
        public string Note { get; set; }
    }
}