using System;
using System.Collections.Generic;

namespace ABA.Models.Wrappers
{
    public class PagedResponse<TItem>: Response<List<TItem>>
    {
        private int filteredItemsCount;

        private int maxPageItemsCount;
        private int pageNumber;

        private int? totalItemsCount;

        public int PageNumber
        {
            get => pageNumber > TotalPagesCount ? TotalPagesCount : pageNumber;
            set => pageNumber = value < 1 ? 1 : value;
        }

        public int PageItemsCount => Content == null ? 0 : Content.Count;

        public int MaxPageItemsCount
        {
            get => maxPageItemsCount;
            set => maxPageItemsCount = value < 1 ? 1 : value;
        }

        public int FilteredItemsCount
        {
            get => filteredItemsCount > TotalItemsCount ? TotalItemsCount : filteredItemsCount;
            set => filteredItemsCount = value < 0 ? 0 : value;
        }

        public int TotalItemsCount
        {
            get => !totalItemsCount.HasValue || totalItemsCount.Value < PageItemsCount ? PageItemsCount : totalItemsCount.Value;
            set => totalItemsCount = value < 0 ? 0 : value;
        }

        public int TotalPagesCount => (int) Math.Floor((double) Math.Min(FilteredItemsCount, TotalItemsCount) / MaxPageItemsCount) + 1;

        public PagedResponse()
        {
            Content = new List<TItem>();
        }
    }
}