using System.Collections.Generic;
using ABA.DataTransferObjects.Validation;

namespace ABA.DataTransferObjects.Request
{
    public class RequestToValidateDto: RequestDto
    {
        public IEnumerable<MconnectValidationDto> MconnectValidations { get; set; }
    }
}