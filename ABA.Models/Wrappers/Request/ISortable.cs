namespace ABA.Models.Wrappers.Request
{
    public interface ISortable
    {
        string SortField { set; get; }
        int SortOrder { set; get; }
    }
}