using ABA.Models.Wrappers.Request;

namespace ABA.DataTransferObjects.License
{
    public class LicenseFilterDto: ISortable, IPagination, IFilter
    {
        public string SortField { set; get; }
        public int SortOrder { set; get; }
        public int StatusId { get; set; }
        public int Page { get; set; }
        public int PageSize { get; set; }
        public string Keyword { get; set; }
        
        public string CitizenIdnp { get; set; }
    }
}