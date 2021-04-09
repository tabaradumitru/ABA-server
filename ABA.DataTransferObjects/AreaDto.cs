using System.Collections.Generic;

namespace ABA.DataTransferObjects
{
    public class AreaDto
    {
        public int AreaId { get; set; }
        public string AreaName { get; set; }
        public List<DistrictDto> Districts { get; set; }
    }
}