using System.Collections.Generic;

namespace ABA.DataTransferObjects
{
    public class LocalitiesDto
    {
        public List<AreaDto> Areas { get; set; }
        public List<DistrictDto> Districts { get; set; }
        public List<LocalityDto> Localities { get; set; }
    }
}