using System.Collections.Generic;

namespace ABA.DataTransferObjects.Validation
{
    public class MconnectValidationDto
    {
        public int ValidationTypeId { get; set; }
        public string ValidationTypeName { get; set; }
        public List<string> ValidationValues { get; set; }
    }
}