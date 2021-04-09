using ABA.Models.Wrappers.Request;

namespace ABA.DataTransferObjects.Request
{
    public class RequestFilter: ISortable, IPagination, IFilter
    {
        public string SortField { set; get; }
        public int SortOrder { set; get; }
        public int StatusId { get; set; }
        public int Page { get; set; }
        public int PageSize { get; set; }
        
        public string Keyword { get; set; }
        
        
    }
}