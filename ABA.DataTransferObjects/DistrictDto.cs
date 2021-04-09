using System.Collections.Generic;

namespace ABA.DataTransferObjects
{
    public class DistrictDto
    {
        public int DistrictId { get; set; }
        public string DistrictName { get; set; }
        public int AreaId { get; set; }
        public List<LocalityDto> Localities { get; set; }
    }
}