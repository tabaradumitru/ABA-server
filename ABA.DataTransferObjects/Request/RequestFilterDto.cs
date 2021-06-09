using System;
using ABA.Models.Wrappers.Request;

namespace ABA.DataTransferObjects.Request
{
    public class RequestFilterDto: ISortable, IPagination, IFilter
    {
        public string SortField { set; get; }
        public int SortOrder { set; get; }
        
        public int Page { get; set; }
        public int PageSize { get; set; }
        
        
        public string Keyword { get; set; }


        public string CitizenIdnp { get; set; }
        public int? ActivityId { get; set; }
        public string LocalityName { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int? StatusId { get; set; }
    }
}